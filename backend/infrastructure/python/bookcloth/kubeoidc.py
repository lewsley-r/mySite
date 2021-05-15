import yaml
import urllib
import subprocess
import json
import click

def create_admin(username, yes):
    if not (yes or click.confirm("Producing YAML for new administrator \"%s\". Go ahead?\n" % username)):
        click.echo(click.style("Exiting on request", fg='blue'))
        return 0

    with open('kubernetes/templates/clusterrolebinding-oidc.yaml', 'r') as example_file:
        example = yaml.load(example_file)

    example['metadata']['name'] = 'admin-binding-%s' % username
    example['subjects'][0] = username

    print(yaml.dump(example, indent=2, default_flow_style=False))

def send_user_instructions(username):
    subject = 'Kubernetes Cluster Access'
    with open('client_secrets.json', 'r') as json_file:
        client_json = json_file.read()
    body = """
    You have access to a Kubernetes cluster:
%s
    """.join(json.dumps(client_json, indent=2, default_flow_style=False))

    subprocess.run([
        'xdg-open',
        'mailto://{username}?subject={subject}&body={body}'.format({
            'username': urllib.parse.urlencode(username),
            'subject': urllib.parse.urlencode(subject),
            'body': urllib.parse.urlencode(body)
        })
    ])
