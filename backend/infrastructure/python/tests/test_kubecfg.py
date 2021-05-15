import pytest
import io
import yaml
from bookcloth import kubecfg
from unittest.mock import mock_open, patch, MagicMock

yaml_file = """
laravel-nginx:
  image:
    repository: flaxandteal/buckram-nginx
    tag: stable
  ingress:
    hostname: DNS.DOMAIN
  laravel:
    serverName: DNS.DOMAIN
laravel-phpfpm:
  image:
    repository: flaxandteal/buckram-phpfpm
    tag: stable
  workerImage:
    repository: flaxandteal/buckram-phpfpm
    tag: stable
  laravel:
    app:
      appKey: base64:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      appUrl: "https://DNS.DOMAIN"
      oauthPublicKey: OAUTH_PUBLIC_KEY_B64
      oauthPrivateKey: OAUTH_PRIVATE_KEY_B64
postgresql:
  postgresqlPassword: xxxxxxxxx
redis:
  password: xxxxxxxxxx
"""

def test_initialize_runs():
    m = mock_open(read_data=yaml_file)
    m_input = MagicMock(return_value='foo')
    with patch('bookcloth.kubecfg.open', m, create=True), \
            patch('builtins.input', m_input):
        kubecfg.initialize(False, False, None)
