$LOAD_PATH.unshift File.dirname(__FILE__)

# require use library
require 'thor'
require 'aws-sdk'
require 'yaml'
require 'erb'
require 'uri'
require 'ruby-progressbar'
require 'parallel'
require 'date'

# require s3cli component
require "s3cli/base"
require "s3cli/ls"
require "s3cli/mb"
require "s3cli/rm"
require "s3cli/put"
require "s3cli/get"
require "s3cli/touch"
require "s3cli/version"
