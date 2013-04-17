# Singer tests

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

require_relative './singer'


describe "Singer tests" do

  singer = Singer.new({:project_name => "foo"})
  
  
  it "should create a project folder \'foo\'" do
    singer.make_folder_project().must_equal singer.project_path
    Dir.rmdir(singer.project_name)
  end

  it "should raise File Exists error if project folder exists" do
    singer.make_folder_project()
    proc { singer.make_folder_project() }.must_raise Errno::EEXIST
    Dir.rmdir(singer.project_name)
  end

end
