from setuptools import find_packages, setup

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
    package_data={'poxload': ['py.typed'],
    '': ['csv.typed']},
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'poxload=poxload:__main__',
            'poxload_batch=poxload_batch:__main__'
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

