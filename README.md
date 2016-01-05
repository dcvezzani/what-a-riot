README.md

Getting started
---------------

Start up PostgreSql if it's not running already.  Set up databases and tables.

    rake db:create
    mkdir db/migrate
    rake db:migrate db:migrate:status
    rake db:test:prepare


Watch for changes to files and run appropriate tests.

    rake watchr


Adding another model.

    rails g model blah name:text
    rake db:migrate db:migrate:status
    rake db:test:prepare


Creating a new integration test.

    rails g steak:spec comments


Riot Examples
-------------

* [Simple example](http://localhost:3672/riot.html)
* [RiotControl example](http://localhost:3672/index-02.html) starting with a [static data source](https://github.com/jimsparkman/RiotControl/tree/master/demo) and moving to a dynamic one using service calls

