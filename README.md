Shorty Challenge
================

This is the solution I came up with for the Shorty Challenge. I use Sinatra to handle the requests, Sequel to handle the data storing on sqlite3, and rspec to test the application. To generate the random shortcodes I use a lib called hashid.

## Install

Run `sudo ./installer.sh` to install the needed dependencies to run the application.

## Run the Api
Run `puma` to start the application in development mode.

Run `puma -e production` to start the application in production mode. (No real difference from development mode)

The application will be listening to http://localhost:9292

## Test
Run `rspec` to run the full test case.
