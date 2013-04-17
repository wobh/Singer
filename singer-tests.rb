# Singer tests

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

require_relative './singer'


describe "Singer tests" do

  singer = Singer.new(:project_name => "foo",
                      :with_gemfile => true,
                      :with_appfile => true)

  
  it "should create a project folder \'foo\'" do
    # skip
    singer.make_folder_project.path.must_equal singer.project_path
    singer.remove()
  end

  it "should raise File Exists error if project folder exists" do
    # skip
    proc {
      singer.make_folder_project()
      singer.make_folder_project()
    }.must_raise Errno::EEXIST
    singer.remove()
  end

  it "should create public and views folders" do
    # skip
    singer.make_folder_project()
    
    public_dir = singer.make_folder_public()
    public_dir.path.must_equal File.join(singer.project_path, "public")

    view_dir = singer.make_folder_views()
    view_dir.path.must_equal File.join(singer.project_path, "views")

    singer.remove()
  end

  it "should create a gemfile" do
    # skip
    singer.make_folder_project()

    singer.make_gemfile()
    
    gemfile_path = File.join(singer.project_path, 'Gemfile')
    File.open(gemfile_path, 'r') { |f| f.read }.must_equal singer.gemfile_text

    singer.remove()
  end

  it "should create an appfile" do
    # skip
    singer.make_folder_project()

    singer.make_appfile()
    
    appfile_path = File.join(singer.project_path, "#{singer.project_name}.rb")
    File.open(appfile_path, 'r') { |f| f.read }.must_equal singer.appfile_text

    singer.remove()    
  end
end
