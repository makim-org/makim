"""Tests for the Makim command-line interface."""

import subprocess
import sys

import pytest

from makim import __version__


@pytest.mark.parametrize('version_flag', ['--version', '-v'])
def test_version_without_config(tmp_path, version_flag):
    """Version command should work without a Makim config file."""
    result = subprocess.run(
        [sys.executable, '-m', 'makim', version_flag],
        cwd=tmp_path,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 0
    assert f'Version: {__version__}' in result.stdout
