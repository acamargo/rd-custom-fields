# RD Custom Fields

  This application is a contact list where the user can define custom fields in
   the contact record.

  When you access the app you create an user which holds contacts records
   and custom fields definitions.

## How to run it locally

  * Install PostgreSQL RDBMS

    Follow the instructions on https://wiki.postgresql.org/wiki/Detailed_installation_guides

  * After the server is up and running, create a new PostgreSQL role to be used by the application

    ```
    $ createuser -P rd-custom-fields
    ```

    * When prompted to setup a password, please type: rd-custom-fields

  * Install RVM

    Follow the instructions on https://rvm.io/rvm/install

  * Install Ruby 2.3.0

    ```
    $ rvm install 2.3.0
    ```

  * Install Bundler gem

    ```
    $ gem install bundler
    ```

  * Install Git

    Follow the instructions on https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

  * Clone this git repository

    ```
    $ git clone https://github.com/acamargo/rd-custom-fields.git
    ```

  * Install the gems required by the application

    ```
    $ cd rd-custom-fields
    $ bundle install
    ```

  * Create the database

    ```
    $ rake db:create
    ```

  * Run the migrations

    ```
    $ rake db:migrate
    ```

  * Run the tests

    ```
    $ rake
    ```

  * Start the web server

    ```
    $ rails server
    ```

  * Open you browser at http://localhost:3000
