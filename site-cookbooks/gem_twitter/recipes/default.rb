#
# Cookbook Name:: gem_twitter
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

gem_package 'twitter' do
  # gem_binary "/path/to/gem_bin"
  action :upgrade
end