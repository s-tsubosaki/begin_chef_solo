#
# Cookbook Name:: ruby-build
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

git "/tmp/ruby-build" do
  user node[:user][:name]
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :checkout
end

bash "install-rubybuild" do
  # not_if で、存在する場合は何もしない設定にできる
  not_if 'which ruby-build'
  code <<-EOC
    cd /tmp/ruby-build
    ./install.sh 
  EOC
end
