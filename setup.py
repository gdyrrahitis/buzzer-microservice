#!/usr/bin/env python
# flake8: noqa
from setuptools import find_packages, setup

setup(
    name='pi-commander-microservice',
    version='0.0.1',
    description='Send commands to connected Raspberry Pi deveices',
    install_requires=[
        'nameko==v3.0.0-rc6',
        'psycopg2-binary==2.8.2',
        'rabbitpy==2.0.1',
        'python-dotenv==0.9.1'
    ],
    extras_require={
        'dev': [
            'pytest==4.5.0',
            'coverage==4.5.3',
            'flake8==3.7.7',
        ],
    },
    zip_safe=True
)
