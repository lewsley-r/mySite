import os
from jinja2 import Template
import click
import shutil

local_settings = {
    'laravel': {
        'server_name': 'localhost'
    },
    'redis': {
        'pass': ''
    },
    'db': {
        'connection': 'pgsql',
        'host': 'db',
        'port': '5432',
        'user': 'laravel',
        'password': 'laravel',
        'database': 'laravel'
    }
}

def setup_local(laravel_dir='.', buckram_dir='./infrastructure', frontend=None, force=False):
    """Set up Laravel for docker-compose locally."""

    docker_compose_file = os.path.join(laravel_dir, 'docker-compose.yml')
    docker_live_dir = os.path.join(laravel_dir, 'docker')
    gitignore_file = os.path.join(laravel_dir, '.gitignore')
    template_dir = os.path.join(buckram_dir, 'templates')
    utils_dir = os.path.join(buckram_dir, 'utils')

    for subdir in ['config', 'storage', 'certificates']:
        os.makedirs(os.path.join(docker_live_dir, subdir), exist_ok=True)

    if force or not os.path.exists(docker_compose_file):
        docker_compose_from_template(
            laravel_dir,
            buckram_dir,
            docker_live_dir,
            target=docker_compose_file,
            frontend=frontend
        )
    else:
        click.echo('Skipping existing docker-compose.yml file')

    config_templates = ['laravel.env', 'redis.env']
    for config_template in config_templates:
        config_output = os.path.join(docker_live_dir, 'config', config_template)
        config_input = os.path.join(template_dir, '{input}.tpl'.format(input=config_template))

        if force or not os.path.exists(config_output):
            click.echo('Creating config: {config}'.format(config=config_output))

            with open(config_input, 'r') as template_fo:
                template = Template(template_fo.read())

            output = template.render(
                db=local_settings['db'],
                laravel=local_settings['laravel'],
                redis=local_settings['redis']
            )

            with open(config_output, 'w') as output_fo:
                output_fo.write(output)

    dartisan_source = os.path.join(buckram_dir, 'utils', 'dartisan')
    dartisan_target = os.path.join(laravel_dir, 'dartisan')
    if force or not os.path.exists(dartisan_target):
        click.echo('Adding in dartisan')
        shutil.copyfile(dartisan_source, dartisan_target)
        os.chmod(dartisan_target, 0o755)

    gitignore_file = os.path.join(laravel_dir, '.gitignore')
    updated_gitignore = False
    with open(gitignore_file, 'r+') as gitignore_fo:
        ignore_lines = [l.strip() for l in gitignore_fo.readlines()]
        new_lines = []

        if '/docker' not in ignore_lines:
            new_lines.append('/docker')

        if new_lines:
            updated_gitignore = True
            gitignore_fo.write('\n' + '\n'.join(new_lines))

    if updated_gitignore:
        click.echo('Updated .gitignore')
    else:
        click.echo('No .gitignore update required')

    click.echo('Warning: to avoid the need for elevated permissions, this sets several directories world-writeable')
    permission_errors = 0
    for writeable_subdir in ['storage/logs', 'storage/framework', 'bootstrap/cache']:
        click.echo(' - ' + writeable_subdir)
        for root, subdirs, files in os.walk(os.path.join(laravel_dir, writeable_subdir)):
            for subdir in subdirs:
                try:
                    os.chmod(os.path.join(root, subdir), 0o777)
                except PermissionError:
                    permission_errors += 1
            for fil in files:
                try:
                    os.chmod(os.path.join(root, fil), 0o777)
                except PermissionError:
                    permission_errors += 1
    click.echo('You can manually change group ownership, for instance, and remove the world writeability')
    if permission_errors:
        click.echo('[there were %d permission-changing error(s): if owned by the web-user, this is normal]' % permission_errors)

    click.echo('\nNEXT STEPS\n---------\n')
    click.echo('In one window, start the app: docker-compose up')
    click.echo('In another, you can run artisan commands...')
    click.echo('On a fresh app, you will likely want to set an application key:\n\t- ./dartisan key:generate')
    click.echo('You may wish to run the migrations:\n\t- ./dartisan migrate')


def docker_compose_from_template(
        laravel_dir, buckram_dir, docker_live_dir, target='docker-compose.yml', frontend=None):
    """Create a new docker-compose file for local Laravel."""

    template_file = os.path.join(buckram_dir, 'templates', 'docker-compose.yml.tpl')

    click.echo(
        'Creating docker-compose.yml file from template: {template_file}'.format(
            template_file=template_file
        )
    )

    with open(template_file, 'r') as template_fo:
        template = Template(template_fo.read())

    output = template.render(
        frontend=frontend,
        buckram=buckram_dir,
        laravel=laravel_dir,
        docker=docker_live_dir
    )

    with open(target, 'w') as output_fo:
        output_fo.write(output)
