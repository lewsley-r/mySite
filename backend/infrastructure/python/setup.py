#!/usr/bin/env python

from setuptools import setup, find_packages

setup(
    name='bookcloth',
    version='1.0',
    description='Tools for Laravel, Docker and Kubernetes',
    author='Phil Weir',
    author_email='info@flaxandteal.co.uk',
    include_package_data=True,
    url='https://gitlab.com/flaxandteal/buckram',
    packages=find_packages(),
    entry_points='''
        [console_scripts]
        bookcloth=bookcloth.scripts.bookcloth:main
    ''',
    install_requires=[
        'click',
        'pyyaml',
        'pycryptodome',
        'jinja2'
    ]
 )
