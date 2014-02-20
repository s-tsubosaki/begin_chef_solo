#
# Cookbook Name:: hello
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# #7開始
log "Hello, Chef!"

%w{gcc make}.each do |pkg|
  package pkg do
    action :install
  end
end