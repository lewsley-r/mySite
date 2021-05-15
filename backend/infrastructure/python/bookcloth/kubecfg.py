import click
import string
import os
import base64
import sys
import yaml
from Crypto.PublicKey import RSA

from .utils import input_default

try:
    from secrets import token_bytes, choice
except ImportError:
    import random
    token_bytes = os.urandom
    choice = random.SystemRandom().choice

def initialize(force, defaults, example_file):
    """Generate a values.yaml for Buckram."""

    click.echo("Generating a values.yaml")

    if os.path.exists('values.yaml') and not force:
        print("A values.yaml file already exists, use --force if sure.")
        sys.exit(1)

    with open(example_file, 'r') as example_fo:
        example = yaml.load(example_fo)

    appKey = base64.b64encode(token_bytes(32))
    example['laravel-phpfpm']['laravel']['app']['appKey'] = str('base64:' + appKey.decode('ascii'))

    pass_set = string.ascii_letters + string.digits + '_+-=&^%$*@#~'
    password = ''.join([choice(pass_set) for __ in range(20)])
    example['redis']['password'] = password

    password = ''.join([choice(pass_set) for __ in range(20)])
    example['postgresql']['postgresqlPassword'] = password

    appKey = base64.b64encode(token_bytes(32))
    example['laravel-phpfpm']['laravel']['app']['appKey'] = str('base64:' + appKey.decode('ascii'))

    oauthKey = RSA.generate(4096)
    example['laravel-phpfpm']['laravel']['app']['oauthPrivateKey'] = base64.b64encode(oauthKey.exportKey()).decode('ascii')
    example['laravel-phpfpm']['laravel']['app']['oauthPublicKey'] = base64.b64encode(oauthKey.publickey().exportKey()).decode('ascii')

    url = input_default('Domain name for the site (FQDN)', 'buckram-laravel-nginx', use_defaults=defaults)
    repository_nginx = input_default('Image repository for nginx', 'flaxandteal/buckram-nginx', use_defaults=defaults)
    tag_nginx = input_default('Tag for buckram-nginx', 'latest', use_defaults=defaults)
    repository_phpfpm = input_default('Image repository for phpfpm', 'flaxandteal/buckram-phpfpm', use_defaults=defaults)
    tag_phpfpm = input_default('Tag for buckram-phpfpm', 'latest', use_defaults=defaults)

    example['laravel-nginx']['laravel']['serverName'] = url
    example['laravel-phpfpm']['laravel']['app']['appUrl'] = 'https://%s' % url
    example['laravel-phpfpm']['image']['repository'] = repository_phpfpm
    example['laravel-phpfpm']['image']['tag'] = tag_phpfpm
    example['laravel-phpfpm']['workerImage']['repository'] = repository_phpfpm
    example['laravel-phpfpm']['workerImage']['tag'] = tag_phpfpm
    example['laravel-nginx']['ingress']['hostname'] = url
    example['laravel-nginx']['image']['repository'] = repository_nginx
    example['laravel-nginx']['image']['tag'] = tag_nginx

    with open('values.yaml', 'w') as real_file:
        yaml.dump(example, real_file, indent=2, default_flow_style=False)

    print("Output written to ./values.yaml")
