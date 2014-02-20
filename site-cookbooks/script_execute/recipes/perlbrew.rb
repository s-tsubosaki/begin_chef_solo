#
# Cookbook Name:: script_execute
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

current_user_name = node[:current_user]
home_directory = node[:etc][:passwd][current_user_name][:dir]

# script (bash)
bash "install perlbrew" do
  user current_user_name
  group current_user_name
  cwd home_directory
  environment "HOME" => home_directory

  code <<-EOC
    curl -kL http://install.perlbrew.pl | bash
  EOC

  not_if "test -f #{home_directory}/perl5/perlbrew/bin/perlbrew", :user => 'root', :environment => { 'HOME' => home_directory }
end
