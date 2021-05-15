import subprocess
import urllib
import json
import sys
import base64
import os
import click
import string

from bookcloth import kubecfg
from bookcloth import kubeoidc
from bookcloth import docker
from bookcloth.utils import input_default

def local_dir():
    return os.path.dirname(os.path.realpath(__file__))

@click.group()
def main():
    pass

@main.command(name='oidc:send-user-instructions', help="Send OIDC user instructions")
@click.argument('username')
def send_user_instructions(username):
    """Prepare an email to a user with login instructions for OIDC"""

    kubeoidc.send_user_instructions(username)

@main.command(name='oidc:create-admin', help="Create OIDC user")
@click.argument('username')
@click.option('--yes', '-y', is_flag=True, help="Answer Yes to all confirmation prompts")
def create_admin(username, yes):
    """Create an administrative user authenticating through OIDC."""

    kubeoidc.create_admin(username, yes)

@main.command(name='kube:initialize')
@click.option('--force/--no-force', default=False, help='Overwrite existing values.yaml')
@click.option('--defaults/--no-defaults', default=False, help='Use dummy default options')
@click.argument('example_file')
def kube_initialize(force, defaults, example_file):
    """Generate a values.yaml for Buckram."""

    kubecfg.initialize(force, defaults, example_file)

@main.command(name='local:initialize')
@click.option('--laravel', default='.', help='Laravel directory')
@click.option('--buckram', default='./infrastructure', help='Buckram location')
@click.option('--frontend', default=None, help='Directory of a separate VueJS frontend, if applicable')
@click.option('--force/--no-force', default=False, help='Overwrite existing files')
def local_initialize(laravel, buckram, frontend, force):
    """Generate a values.yaml for Buckram."""

    docker.setup_local(laravel, buckram, frontend, force=force)
