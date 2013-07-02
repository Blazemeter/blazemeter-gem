# Blazemeter

BlazeMeter is add-on that provides an integrated self-service, on-demand, cloud-based, 100% JMeter 
compatible load and performance testing for your web and mobile apps. BlazeMeter provides developers 
and QA professionals the ability to script complex user sequences and scenarios to execute extra high 
capacity loads using a self-service, on demand platform.

## Installation

Add this line to your application's Gemfile:

    gem 'blazemeter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blazemeter

## Usage

You can use BlazeMeter either from command line or from your Ruby code. 

### Command line usage

First you must initialize your Blazemeter instance:

    blazemeter api:init
	
or
	
	blazemeter api:init -a XXXYYY

This will prompt you to enter your user key which will be saved so you don't need to do it again.
However if you want to change your user key you can do it by removing the current key using api:reset command:

    blazemeter api:reset

To create a new test:

     blazemeter test:create
	 
-this will prompt you to enter test name, max users (or max users per load engine if -en is set), location, jmeter version, ramp up, iterations, duration and number of engines for the test.
-you can also prefil those values in command line:

     blazemeter test:create -u 1000 -n mytestname -l us-west-1 -j 2.9 -r 300 -i 100 -d 100 -en 2

To start a test:

     blazemeter test:start
	 
or

     blazemeter test:start -id 123

To stop a test:

     blazemeter test:stop
	 
or

     blazemeter test:start -id 123

To update a test:

     blazemeter test:update
	 
-this will prompt you to enter test id, max users (or max users per load engine if -en is set), location, jmeter version, ramp up, iterations, duration and number of engines for the test
-you can also prefil those values

     blazemeter test:update -id 123 -u 500 -l us-east-1 -j 2.9 -r 300 -i 100 -d 100 -en 2
	 
To get test status:

     blazemeter test:status
	 
or

     blazemeter test:status -id 123
	 
To get test options:

     blazemeter test:options
	 
or

     blazemeter test:options -id 123	 

To get list of valid locations:

     blazemeter help:locations

### Usage from the Ruby code

To use BlazeMeter in your ruby code, first you must include it:

     require "blazemeter"

Then you can instantiate BlazeMeter class with your user key:

     blaze = BlazemeterApi.new('12345678')

To create a new test:

     test_id = blaze.testCreate(test_name, options)

To start a test:

     blaze.testStart(test_id)

To stop a test:

     blaze.testStop(test_id)

To update a test:

     blaze.testUpdate(test_id, options)

To get test status:

     blaze.testGetStatus(test_id)

