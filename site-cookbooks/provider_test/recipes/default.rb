#
# Cookbook Name:: provider_test
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

Chef::Log.info "by chef log info"

user_name = node[:current_user]
home_directory = node[:etc][:passwd][node[:current_user]][:dir]

file "#{home_directory}/tmp0.text" do
  owner user_name
  group user_name
  mode 0644
  content <<-EOC
    tmp0
  EOC
  action :create
end

file "#{home_directory}/tmp1.text" do
  owner user_name
  group user_name
  mode 0644
  content <<-EOC
    tmp0
  EOC
  action :create
end

tmp_file "#{home_directory}/tmp.text" do
  user_name user_name
end