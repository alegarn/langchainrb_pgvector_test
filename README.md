# langchainrb_pgvector_test

Please note that this project is not designed to work on systems other than Linux. (nothing personal, not a huge project)

## Pre-installation Requirements

Before starting with the installation process, make sure you have the following pre-installation requirements:

- Update and upgrade your system:
  ```
  $ sudo apt update
  $ sudo apt upgrade
  ```

- Install PostgreSQL: [PostgreSQL Installation Guide](https://www.postgresqltutorial.com/postgresql-getting-started/install-postgresql/)
- Install Ruby (version 3.2.2): [Ruby Installation Guide](https://www.ruby-lang.org/en/documentation/installation/#rvm)
- Install Bundler: [Bundler Installation Guide](https://www.jetbrains.com/help/ruby/using-the-bundler.html#install_bundler)
- Install pgvector for Linux (Ubuntu/Debian):
  ```
  $ psql --version
  # psql (PostgreSQL) XX.X (...)
  # your_pg_version_number = XX
  $ sudo apt install postgresql-your_pg_version_number-pgvector
  ```

If you encounter any issues with superuser permissions, follow the steps mentioned in the [Server Fault post](https://serverfault.com/questions/110154/whats-the-default-superuser-username-password-for-postgres-after-a-new-install) to add a superuser.

Make sure you also have your API key for OpenAI ready before proceeding with the installation.
Visit https://platform.openai.com/api-keys and copy your newly created key.

## How to Launch

To launch the project, follow these steps:

1. Open your terminal and navigate to the project directory:
   ```
   $ cd directory/path
   ```

2. Set your OpenAI API key in the `.env` file:
   First create .env in the root directory, where you have index.rb file.
   
   Then in the file:
   ```
   OPENAI_API_KEY=your_api_key_here
   ```

3. Run the following command to start the project:
   ```
   $ ruby index.rb
   ```

## Description

This project is a terminal-based application built using the langchainrb gem. It utilizes a local pgvector database and integrates with OpenAI for embeddings and chat functionalities.

## Features

The project includes the following features:

- Load PDF files into the pgsql vector database
- Use queries to interact with the PDF files
- Modify vector database parameters and model parameters
- Exit the application (cleaner than CTRL+C)
- Instructions on how to delete the database


Feel free to explore this open-source project!