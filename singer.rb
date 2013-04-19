#!/usr/bin/env ruby

# Singer
# build new sinatra projects

require 'fileutils'

class Singer
  attr_reader :project_name, :project_path
  attr_reader :gemfile_text, :appfile_text
  attr_reader :build_opts

  def set_opts(args)
    @build_opts = {}
    @build_opts.update(args)
  end
  
  def initialize (args)
    set_opts(args)
    @project_name = build_opts[:project_name]
    
    if build_opts[:with_gemfile]
      @gemfile_text = <<-EOF
# #{project_name} Gems

source 'https://rubygems.org'

gem 'sinatra', :github => "sinatra/sinatra"
gem 'sinatra-contrib', :github => "sinatra/sinatra-contrib"
EOF
    end

    if build_opts[:with_appfile]
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
    pubdir = 'public'
    make_path_in_project(pubdir)
    if build_opts[:fill_public]
      ['stylesheets', 'javascript', 'images'].each do |dirname|
        make_path_in_project(File.join(pubdir, dirname))
      end
    end
    return File.join(project_path, pubdir)
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
    if build_opts[:with_public]
      make_folder_public()
    end

    if build_opts[:with_views]
      make_folder_views()
    end

    if build_opts[:with_appfile]
      make_appfile()
    end

    if build_opts[:with_gemfile]
      make_gemfile()
    end
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

  optparse = OptionParser.new do |opts|
    opts.banner = "Usage: singer.rb [OPTIONS] PROJECT_NAME"

    opts.on("-g", "--gemfile", "Build a Gemfile in project") do
      options[:with_gemfile] = true
    end

    opts.on("-a", "--appfile", "Build an app file in project") do
      options[:with_appfile] = true
    end

    opts.on("--public", "Build a public folder in project") do
      options[:with_public] = true
    end

    opts.on("--public-fill", "Build a public folder with some standard sub-folders") do
      options[:with_public] = true
      options[:fill_public] = true
    end

    opts.on("--views", "Build a views folder in project") do
      options[:with_views] = true
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
    
  end.parse!

  # Parse first remaining argument in ARGV
  if ARGV.empty?
    puts optparse
    exit
  else
    options[:project_name] = ARGV[0]
  end


  singer = Singer.new(options)
  singer.create()
  
end

