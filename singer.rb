#!/usr/bin/env ruby

# Singer
# build new sinatra projects

require 'fileutils'

class Singer
  attr_reader :project_name, :project_path
  
  def initialize (args)
    @project_name = args[:project_name]
  end

  def make_folder_project()
    # Make a project file or error
    FileUtils.mkdir(project_name)
    @project_path = Dir.new(project_name)
  end
  
  def create()
    # Create project
    make_folder_project()
  end

  def remove()
    # Remove project
    FileUtils.rm_rf(project_name)
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
  singer.create()
  
end

