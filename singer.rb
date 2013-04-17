#!/usr/bin/env ruby

# Singer
# build new sinatra projects

class Singer
  attr_reader :project_name, :project_path
  
  def initialize (args)
    @project_name = args[:project_name]
  end

  def make_folder_project()
    # make a project file or error
    Dir.mkdir(project_name)
    @project_path = Dir.new(project_name)
  end

  def make_project()
    # Make whole project
    make_folder_project()
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'optparse'

  options = {}

  OptionParser.new do |opts|
    opts.banner = "Usage: singer.rb [OPTIONS] PROJECT_NAME"


    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
    
    if ARGV == []
      puts opts
      exit
    else
      options[:project_name] = ARGV[0]
    end

  end.parse!

  
  singer = Singer.new(options)
  singer.make_project
  
end

