# IaC - Test 2

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com)

This project contains Infrastructure-as-Code resources.

## Local Development

- Ensure the following tools are installed and active.

  - [direnv](https://direnv.net)
  - [task](https://taskfile.dev)
  - [terraform](https://www.terraform.io)
  - [terraform-docs](https://terraform-docs.io)
  - [checkov](https://checkov.io)
  - [pre-commit](https://pre-commit.com)
  - [check-jsonschema](https://check-jsonschema.readthedocs.io)

- Clone this repository

  ``` shell
  cd <target_directory>
  git clone git@github.com:qaware/workshop-agenda-bootstrap.git
  cd workshop-agenda-bootstrap
  ```

- Create a `.envrc` file based on the example template.

  ``` shell
  cp .example.envrc .envrc
  ```

- Allow direnv to load the `.envrc` file.

  ``` shell
  direnv allow .
  ```

- Show available tasks

  ``` shell
  task --list
  ```
