from setuptools import find_packages, setup

import subprocess

import setuptools

from distutils.command.build import build as _build  # isort:skip


# This class handles the pip install mechanism.
class build(_build):  # pylint: disable=invalid-name
  """A build command class that will be invoked during package install.

  The package built using the current setup.py will be staged and later
  installed in the worker using `pip install package'. This class will be
  instantiated during install for this specific scenario and will trigger
  running the custom commands specified.
  """
  sub_commands = _build.sub_commands + [('CustomCommands', None)]


# Some custom command to run during setup. The command is not essential for this
# workflow. It is used here as an example. Each command will spawn a child
# process. Typically, these commands will include steps to install non-Python
# packages. For instance, to install a C++-based library libjpeg62 the following
# two commands will have to be added:
#
#     ['apt-get', 'update'],
#     ['apt-get', '--assume-yes', 'install', 'libjpeg62'],
#
# First, note that there is no need to use the sudo command because the setup
# script runs with appropriate access.
# Second, if apt-get tool is used then the first command needs to be 'apt-get
# update' so the tool refreshes itself and initializes links to download
# repositories.  Without this initial step the other apt-get install commands
# will fail with package not found errors. Note also --assume-yes option which
# shortcuts the interactive confirmation.
#
# Note that in this example custom commands will run after installing required
# packages. If you have a PyPI package that depends on one of the custom
# commands, move installation of the dependent package to the list of custom
# commands, e.g.:
#
#     ['pip', 'install', 'my_package'],
#
# TODO(https://github.com/apache/beam/issues/18568): Output from the custom
# commands are missing from the logs. The output of custom commands (including
# failures) will be logged in the worker-startup log.
CUSTOM_COMMANDS = [['apt-get', 'update'],
                  ['apt-get', '--assume-yes', 'install', 'libxrender1']]


class CustomCommands(setuptools.Command):
  """A setuptools Command class able to run arbitrary commands."""
  def initialize_options(self):
    pass

  def finalize_options(self):
    pass

  def RunCustomCommand(self, command_list):
    print('Running command: %s' % command_list)
    p = subprocess.Popen(
        command_list,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT)
    # Can use communicate(input='y\n'.encode()) if the command run requires
    # some confirmation.
    stdout_data, _ = p.communicate()
    print('Command output: %s' % stdout_data)
    if p.returncode != 0:
      raise RuntimeError(
          'Command %s failed: exit code: %s' % (command_list, p.returncode))

  def run(self):
    for command in CUSTOM_COMMANDS:
      self.RunCustomCommand(command)

__version__ = "1.0"

# Load README
with open('README.md', encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='poxload',
    version='1.0',
    author='Josef Kehrein',
    author_email='josef.kehrein@helsinki.fi',
    license='MIT',
    description='Predict drug loading for poly(2-oxazoline) micelles',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/juppifluppi/poxload',
    download_url=f'https://github.com/juppifluppi/poxload/archive/refs/tags/v_{__version__}.tar.gz',
    project_urls={
        'Source': 'https://github.com/juppifluppi/poxload',
        'Web application': 'http://poxload.streamlit.app',
    },
    packages=find_packages(),
    cmdclass={
        # Command class instantiated and run during pip install scenarios.
        'build': build,
        'CustomCommands': CustomCommands,
    },
    package_data={'poxload': ['py.typed'],
    '': ['csv.typed']},
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'poxload=poxload:main',
            'poxload_batch=poxload_batch:main'
        ]
    },
    install_requires=[
        'numpy',        
        'rdkit>=2022.09.5',    
        'mordredcommunity',
    ],
    python_requires='>=3.7',
    classifiers=[
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: R :: 4.2.2',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent'
    ],
    keywords=[
        'chemistry',
        'property prediction',
        'random forest'
    ]
)
