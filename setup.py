from setuptools import setup, find_packages

setup(
    name="simple-flask-app",
    version="0.1.0",
    packages=find_packages(),
    install_requires=open("requirements.txt").read().splitlines(),
    entry_points={
        "console_scripts": [
            "simple-flask-app=simple_flask_app.app:main"
        ]
    },
)
