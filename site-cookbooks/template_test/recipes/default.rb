#
# Cookbook Name:: template_test
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template '/tmp/template_test.txt' do
  mode 0644
end

gem_package 'json'
template '/tmp/dump_node.json' do
  require 'json'

  variables({
    :node_json => JSON.pretty_generate(node)
  })
end