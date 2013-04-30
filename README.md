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

To create a new test:

     blazemeter testCreate
	 
-this will prompt you to enter USER_KEY, test name, max_users and location for the test.
-you can also prefil those values:

     blazemeter testCreate('my test', 50, 'us-west-1')

To start a test:

     blazemeter testStart
	 
or

     blazemeter testStart(123)

To stop a test:

     blazemeter testStop
	 
or

     blazemeter testStop(123)

To update a test:

     blazemeter testUpdate
	 
-this will prompt you to enter test id, max_users and location for the test.
-you can also prefil those values

     blazemeter testUpdate(123, 30, 'us-west-2')
	 
To get test status:

     blazemeter testGetStatus
	 
or

     blazemeter testGetStatus(123)

To get list of valid locations:

     blazemeter getLocations

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

