# Cookbook Name::npm
# Recipe:: default

version = node[:npm][:version]

 case node['platform']
  when "redhat","centos","scientific","fedora","suse","amazon"
    #action groupinstall not solved: https://tickets.opscode.com/browse/CHEF-1392
    execute "centos dev tools" do  
      command 'yum -y groupinstall "Development Tools"'
    end    
  when "debian","ubuntu"
    #avoiding 'Chef::Exception::Exec returned 100, expected 0' error
    execute "apt-get-update" do  
      command "apt-get update"
    end
    #install dependencies
    npm_install_dependencies =["build-essential","fontconfig","python-software-properties"]
    npm_install_dependencies.each do |pkg|
      package pkg do
        action :install
      end
    end
 end

#compile node from source
# TODO -- Need to check if this is necessary (including a "force" option) as this is slow
bash "compile_node" do
  user "root"
  cwd "/tmp"
  code <<-EOH
   wget http://nodejs.org/dist/#{version}/node-#{version}.tar.gz
   tar xzvf node-#{version}.tar.gz
   cd node-#{version}
   ./configure
   make
   make install
  EOH
  not_if "node --version | grep -q \"$version\""
end

case node['platform']
  when "debian","ubuntu"
    bash "link_node_execs" do
    user "root"
    cwd "/tmp"
    code <<-EOH     
     ln -s /usr/local/bin/npm /usr/bin/npm
     ln -s /usr/local/bin/node /usr/bin/node
    EOH
  end
end


npm_packages =node[:npm][:packages]

#install selected packages
npm_packages.each do |pkg|
    execute "install_npm_packages" do
       command "npm install -g #{pkg}"
       action :run
       not_if "npm ls -global #{pkg}"
    end   
end