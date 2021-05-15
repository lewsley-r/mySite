#!/usr/bin/env python3

import subprocess
import urllib
import json
import sys
import base64
import os
import click
import string
import yaml
from Crypto.PublicKey import RSA

try:
    from secrets import token_bytes, choice
except ImportError:
    import random
    token_bytes = os.urandom
    choice = random.SystemRandom().choice

@click.group()
def main():
    pass

@main.command()
@click.option('--force/--no-force', default=False, help='Overwrite existing production.yaml')
def initialize(force):
    """Generate a production.yaml for Buckram."""
    click.echo("Generating a production.yaml")

    if os.path.exists('production.yaml') and not force:
        print("A production.yaml file already exists, use --force if sure.")
        sys.exit(1)

    with open('config/production.yaml.example', 'r') as example_file:
        example = yaml.load(example_file)

    appKey = base64.b64encode(token_bytes(32))
    example['laravel-phpfpm']['laravel']['app']['appKey'] = str('base64:' + appKey.decode('ascii'))

    pass_set = string.ascii_letters + string.digits + '_+-=&^%$*@#~'
    password = ''.join([choice(pass_set) for __ in range(20)])
    example['redis']['password'] = password

    password = ''.join([choice(pass_set) for __ in range(20)])
    example['postgresql']['postgresPassword'] = password

    appKey = base64.b64encode(token_bytes(32))
    example['laravel-phpfpm']['laravel']['app']['appKey'] = str('base64:' + appKey.decode('ascii'))

    oauthKey = RSA.generate(4096)
    example['laravel-phpfpm']['laravel']['app']['oauthPrivateKey'] = base64.b64encode(oauthKey.exportKey()).decode('ascii')
    example['laravel-phpfpm']['laravel']['app']['oauthPublicKey'] = base64.b64encode(oauthKey.publickey().exportKey()).decode('ascii')

    url = input('Domain name for the site (FQDN): ')
    repository = input('Image repository: ')
    tag_nginx = input('Tag for buckram-nginx: ')
    tag_phpfpm = input('Tag for buckram-phfpm: ')

    example['laravel-nginx']['laravel']['serverName'] = url
    example['laravel-phpfpm']['laravel']['app']['appUrl'] = 'https://%s' % url
    example['laravel-phpfpm']['image']['repository'] = repository
    example['laravel-phpfpm']['image']['tag'] = tag_phpfpm
    example['laravel-phpfpm']['workerImage']['repository'] = repository
    example['laravel-phpfpm']['workerImage']['tag'] = tag_phpfpm
    example['laravel-nginx']['ingress']['hostname'] = url
    example['laravel-nginx']['image']['repository'] = repository
    example['laravel-nginx']['image']['tag'] = tag_nginx

    with open('production.yaml', 'w') as real_file:
        yaml.dump(example, real_file, indent=2, default_flow_style=False)

    print("Output written to ./production.yaml")

if __name__ == '__main__':
    main()
