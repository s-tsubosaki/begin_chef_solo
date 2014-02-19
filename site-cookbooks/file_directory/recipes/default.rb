#
# Cookbook Name:: file_directory
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# ディレクトリ作成
# cookbook_fileで存在しないディレクトリを選んだ場合、chefはそこまで面倒を見てくれない
directory "/tmp/cookbook_file" do
  mode 00755
  owner node[:current_user]
  group node[:current_user]
  action :create
end

cookbook_file "/tmp/cookbook_file/cookbook_file.txt" do
  source 'cookbook_file.txt'
  mode 0644
  owner node[:current_user]
  group node[:current_user]
  # shasum -a 256 $filepath
  checksum "15ba80b541768edee15a01f0a4c68085323863361e8d6d3251129a8e46828dba"
end