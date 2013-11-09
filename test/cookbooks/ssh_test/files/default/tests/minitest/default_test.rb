require 'minitest/spec'
 
describe_recipe 'ssh::default' do
  it "creates a 'root' config" do
    file("/root/.ssh/config").must_exist.with(:mode, "600").with(:owner, "root")
    file("/root/.ssh/config").must_include 'Host github.com'
  end

  it "creates a 'root' known_hosts" do
    file("/root/.ssh/known_hosts").must_exist.with(:mode, "644").with(:owner, "root")
    file("/root/.ssh/known_hosts").must_include 'github.com'
  end

  it "creates a 'vagrant' config" do
    file("/home/vagrant/.ssh/config").must_exist.with(:mode, "600").with(:owner, "vagrant")
    file("/home/vagrant/.ssh/config").must_include 'Host github.com'
  end

  it "creates a 'vagrant' known_hosts" do
    file("/home/vagrant/.ssh/known_hosts").must_exist.with(:mode, "644").with(:owner, "vagrant")
    file("/home/vagrant/.ssh/known_hosts").must_include '|1|' #haha how do you TEST THIS
  end

  it "creates a 'faked' config" do
    file("/tmp/bitty/.ssh/config").must_exist.with(:mode, "600").with(:owner, "faked")
    file("/tmp/bitty/.ssh/config").must_include 'Host github.com'
  end

  it "creates a 'faked' known_hosts" do
    file("/tmp/bitty/.ssh/known_hosts").must_exist.with(:mode, "644").with(:owner, "faked")
    file("/tmp/bitty/.ssh/known_hosts").must_include 'github.com'
  end

  it "creates a 'faked' known_hosts entry for a host with specified port" do
    file("/tmp/bitty/.ssh/known_hosts").must_include 'gitlab.com'
  end

end