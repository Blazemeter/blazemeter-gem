# Blazemeter

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'blazemeter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blazemeter

## Usage

TODO: Write usage instructions

You can use BlazeMeter either from command line or from your Ruby code. 

### Command line usage

First you must initialize your Blazemeter instance:
    blazemeter api:init

This will prompt you to enter your user key which will be saved so you don't need to do it again.
However if you want to change your user key you can do it by using api:login command:

    blazemeter api:login	

To create a new test:

     blazemeter test:create
	 
-this will prompt you to enter test name, max_users and location for the test.
-you can also prefil those values:

     blazemeter test:create -u 1000 -n mytestname -l us-west-1

To start a test:

     blazemeter test:start
	 
or

     blazemeter test:start -i 123

To stop a test:

     blazemeter test:stop
	 
or

     blazemeter test:start -i 123

To update a test:

     blazemeter test:update
	 
-this will prompt you to enter test id, max_users and location for the test.
-you can also prefil those values

     blazemeter test:update -i 123 -u 500 -l us-east-1
	 
To get test status:

     blazemeter test:status
	 
or

     blazemeter test:update -i 123

To get list of valid locations:

     blazemeter help:locations

### Usage from the Ruby code

To use BlazeMeter in your ruby code, first you must include it:

     require "blazemeter"

Then you can instantiate BlazeMeter class with your user key:

     blaze = Blazemeter.new('12345678')

To create a new test:

     test_id = blaze.testCreate(test_name, max_users, location)

To start a test:

     blaze.testStart(test_id)

To stop a test:

     blaze.testStop(test_id)

To update a test:

     blaze.testUpdate(test_id, max_users, location)

To get test status:

     blaze.testGetStatus(test_id)

