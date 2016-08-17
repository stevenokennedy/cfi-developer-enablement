# Cookbook Name::ide
# Recipe:: intellij

version = node[:ide][:intellij][:version]

#download and extract intellij
remote_file '/home/vagrant/WebStorm.tar.gz' do
  source 'https://download.jetbrains.com/webstorm/WebStorm-2016.2.1.tar.gz'
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
  action :create
end

bash "install_ide" do
   user "vagrant"
   cwd "/home/vagrant"
   code <<-EOH
      mkdir WebStorm
      tar xzf WebStorm.tar.gz -C WebStorm --strip-components 1
  EOH
end

   

#create a shortcut file on the desktop
file "/home/vagrant/Desktop/WebStorm.desktop" do
   content <<-SHORTCUT
      #!/usr/bin/env xdg-open
 
      [Desktop Entry]
      Version=1.0
      Type=Application
      Terminal=false
      Exec=/home/vagrant/WebStorm/bin/webstorm.sh
      Name=WebStorm
      Comment=Webstorm IDE
      Icon=/home/vagrant/WebStorm/bin/webstorm.svg
   SHORTCUT
   mode 0700
   owner 'vagrant'
   group 'vagrant'
end

