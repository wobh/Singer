#!/usr/bin/env ruby

# Singer
# build new sinatra projects

require 'fileutils'

class Singer
  attr_reader :project_name, :project_path
  attr_reader :gemfile_text, :appfile_text
  
  def initialize (args)
    @project_name = args[:project_name]
    
    if args[:with_gemfile]
      @gemfile_text = <<-EOF
# #{project_name} Gems

source 'https://rubygems.org'

gem 'sinatra', :github => "sinatra/sinatra"
gem 'sinatra-contrib', :github => "sinatra/sinatra-contrib"
EOF
    end

    if args[:with_appfile]
      @appfile_text = <<-EOF
# #{project_name} Application

require 'sinatra'
require 'sinatra/reloader' if development?
EOF
    end
  end

  
  def make_folder_project()
    # Make a project file or error
    FileUtils.mkdir(project_name)
    @project_path = File.absolute_path(project_name)
    Dir.new(project_path)
  end

  def make_path_in_project(folder_path)
    # make a new path in project
    fullpath = File.join(project_path, folder_path)
    FileUtils.mkdir_p(fullpath)
    return Dir.new(fullpath)
  end

  def make_folder_public
    # Make a public folder
    return make_path_in_project('public')
  end

  def make_folder_views
    # Make a views folder
    return make_path_in_project('views')
  end

  def make_gemfile
    gemfile_path = File.join(project_path, "Gemfile")
    File.open(gemfile_path, "w") { |f| f.write gemfile_text }
  end

  def make_appfile
    appfile_path = File.join(project_path, "#{project_name}.rb")
    File.open(appfile_path, "w") { |f| f.write appfile_text }
  end
  
  def create()
    # Create project
    make_folder_project()
    make_folder_public()
    make_folder_views()
  end

  def remove()
    # Remove project
    FileUtils.remove_dir(project_path)
    @project_path = nil
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

