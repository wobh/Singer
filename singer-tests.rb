# Singer tests

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

require_relative './singer'


describe "Singer tests" do

  singer = Singer.new({:project_name => "foo"})
  
  
  it "should create a project folder \'foo\'" do
    singer.make_folder_project().must_equal singer.project_path
    singer.remove()
  end

  it "should raise File Exists error if project folder exists" do
    proc {
      singer.make_folder_project()
      singer.make_folder_project()
    }.must_raise Errno::EEXIST
    singer.remove()
  end

end
