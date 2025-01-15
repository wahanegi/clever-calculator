# Welcome to the Clever Calculator app
## Introduction

The Clever Calculator app is built using Ruby on Rails. The main functionality of this app is to help sales manager 
to create the best price for customers.

___
## Table of Contents
- [Technologies and System dependencies](#technologies-and-system-dependencies)
- [Additional Files](#additional-files)
- [Installation (MacOS)](#installation-macos)
- [Prerequisites](#prerequisites)
- [Getting started](#getting-started)
- [Rubymine Support for Rubocop (Code Linting)](#rubymine-support-for-rubocop-code-linting)
- [Usage](#usage)
- [Environment Variables](#environment-variables)
- [Testing](#testing)
- [License](#license)

___
## Technologies and System dependencies
Ruby 3.4.1
Rails 8.0.1
PostgreSQL
Bootstrap
React.js
esbuild (for JavaScript bundling)

## Additional Files

```.ruby-version``` and ```.ruby-gemset```  are used to specify the Ruby version and gemset for consistency across environments.

# Installation (MacOS)

## Prerequisites

1. Install the latest version of XCode from the App store, run the following command in terminal:
    ```
    xcode-select --install
    ```
2. Install the latest version of Homebrew: http://brew.sh

3. Install Dependencies for Compiling Ruby Install the required packages for building Ruby. On macOS, run:
    ```
    brew install openssl readline zlib
    ```
4. Install Git on Mac using homebrew:
    ```
    brew install git
    ```
5. Set your GIT username from terminal:
    ```
    git config --global user.name "YOUR NAME"
   ```
6. Set your GIT email address from terminal:
    ```
   git config --global user.email "YOUR EMAIL ADDRESS"
   ```

## Getting started

1. Clone the repository:
	```
    git clone https://github.com/wahanegi/clever-calculator.git
    ```
	```
	cd clever-calculator
    ```
2. Install the latest version of RVM: https://rvm.io

3. Compile Ruby with Custom Options Since precompiled binaries aren’t available, tell RVM to compile Ruby:
	```
    rvm install 3.4.1 --with-openssl-dir=$(brew --prefix openssl)
    ```
4. Specify the Ruby version you want to use:
	```
    rvm use ruby-3.4.1
    ```
5. Create a gemset named `clever-calculator`:
	```
    rvm gemset create clever-calculator
    ```
6. Switch to your newly created gemset:
	```
    rvm gemset use clever-calculator
    ```
7. Install PostgreSQL in terminal:
    ```
   brew install postgresql
    ```
8. Start the PostgreSQL service:
	```
    brew services start postgresql
    ```
9. Verify installation
	```
    psql --version
    ```
10. Install dependencies with Bundler:
	```
    bundle install
    ```
11. Install JavaScript dependencies with Yarn:
    ```
    yarn install
    ```
12. Set up the database:
	```
    rails db:create db:migrate
    ```
13. Start the server:
	```
    bin/dev
    ```
## Rubymine Support for Rubocop (Code Linting)

Code Linting gives formatting and syntax suggestions to make your code more readable.
In Rubymine go to:
```Rubymine -> Preferences -> Editor -> Inspections -> Ruby -> Gems and gems management -> Rubocop```
Make sure that the checkbox is checked.


# Usage
Visit http://localhost:3000 after running the server.

# Environment Variables

Create a ```.env``` file in the root directory and include:
```
DATABASE_USERNAME=your_username
```
```
DATABASE_PASSWORD=your_password
```

# Testing

Run tests with:
```
bundle exec rspec
```

# License
This project is licensed under the MIT License.
