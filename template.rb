#!/usr/bin/env ruby

# Basic libraries for regularly used Ruby standard-lib modules
require "rubygems"
require "bundler/setup"
require "csv"
require "benchmark"
require "securerandom"

# Bundler includes everything in `Gemfile` by default, so you only have to include your own files below
Bundler.require(:default)
# all require_all entries have to be after this, so the gem is loaded properly first
# ----------------------------------------------------------------------------------
# require_all "./some_sub_folder"
# require "./single_file"

program :name, "Ruby CLI Template"
program :version, "0.0.1"
program :description, "A Template for Ruby CLI Apps, CHANGE ME"

command :extract do |c|
  c.syntax = "cli_template.rb run [options]"
  c.summary = "CHANGE ME"
  c.description = "CHANGE ME"
  c.example "Run the template", " <csv_filename>"
  # c.option "--sample_boolean", "A boolean flag example"
  # c.option "--sample_string STRING", String, "A string flag example"

  c.action do |args, options|
    # Args that are passed in without flags, in their order, set defaults here as well if desired
    arg1 = args[0].nil? ? "default_value"  : args[0]
    arg2 = args[1].nil? ? "default_value"  : args[1]

    if options.sample_boolean.nil?
      # This is for testing flags and setting defaults, if you want to do that
    end

    # A sample progress bar, format is ===== : 3/5: 20m"
    progressbar = ProgressBar.create total: 5, format: "%B : %c/%C: %E"

    # Get file names for a directory
    file_names = Dir.entries(Dir.pwd)

    # Check for the system you're running this on. Some GNU tools especially differ between systems
    # Note: This breaks on JRuby, probably anything non MRuby
    if RUBY_PLATFORM.include?("linux")
      command = "******"
    elsif RUBY_PLATFORM.include?("darwin") # MacOS is Darwin
      command = "******"
    end

    # Run the command previously set and get the response
    response = `#{command}`

    # Write a CSV, "a" for append, "wb" for write
    CSV.open("/path/to/file", "a") do |csv|
      csv << ["a", "line", "for", "the", "CSV"]

      # increment the progress bar
      progressbar.increment

      # Log something to the console if using a progress bar
      progressbar.log "Something or another"
    end

    # Finish the progress bar
    progressbar.finish
  end
end

default_command :run
