#
# Cookbook Name:: definition
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cpanm 'Path::Tiny' do
  user_name node[:current_user]
  home_directory node[:etc][:passwd][node[:current_user]][:dir]
  force true
end
