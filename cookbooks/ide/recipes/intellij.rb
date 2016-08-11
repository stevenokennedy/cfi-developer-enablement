# Cookbook Name::ide
# Recipe:: intellij

version = node[:ide][:intellij][:version]

#download and extract intellij
remote_file '/home/vagrant/ideaIC.tar.gz' do
  source 'https://data.services.jetbrains.com/products/download?code=IIC&platform=linux'
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
  action :create
end

bash "install_ide" do
   user "vagrant"
   cwd "/home/vagrant"
   code <<-EOH
      mkdir ideaIC
      tar xzf ideaIC.tar.gz -C ideaIC --strip-components 1
  EOH
end

   

#create a shortcut file on the desktop
file "/home/vagrant/Desktop/Intellij.desktop" do
   content <<-SHORTCUT
      #!/usr/bin/env xdg-open
 
      [Desktop Entry]
      Version=1.0
      Type=Application
      Terminal=false
      Exec=/home/vagrant/ideaIC/bin/idea.sh
      Name=Intellij
      Comment=comment here
      Icon=/home/vagrant/ideaIC/bin/idea.png
   SHORTCUT
   mode 0700
   owner 'vagrant'
   group 'vagrant'
end

