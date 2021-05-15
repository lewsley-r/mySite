# Buckram Bookcloth

This is a quickstart Python tool for helping with Laravel, Kubernetes and Docker.

Usage:

    bookcloth COMMAND

Arguments:

    kube:initialize [--force]

      Take a values.yaml.example file and provide some example randomized settings.

      --force           overwrites the existing values.yaml

    local:initialize

      Set up a local Laravel codebase for docker-compose

    oidc:create-admin USERNAME

      This adds administrative users through OIDC. It will output their credentials to a kubeconfig file called `config-NAME.yaml`.

      Examples:

        bookcloth oidc:create-admin user@example.com | kubectl create -f -

## Installation

In this directory, run:

    pip install --user .

Note the pipe (bookcloth does not interact directly with Kubernetes). While piping is convenient, we recommend saving the output YAML to a file and checking it before running with `kubectl create`.
