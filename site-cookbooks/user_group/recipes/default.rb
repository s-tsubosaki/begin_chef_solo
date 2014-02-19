#
# Cookbook Name:: user_group
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# パスワードジェネレータ
case node[:platform]
when 'ubuntu'
  apt_package 'pwgen'
else
  package 'pwgen'
end

# リソースに渡す第一引数は変数にもできる
user_name = 'chef_user'
# ユーザー作成
user user_name do
  comment user_name
  home "/home/#{user_name}"
  shell "/bin/bash"
  password nil
  # manage_home => trueでusermodで-mオプションがつく
  # 変更先のディレクトリが存在する場合、移動できないのでエラーとなる
  # が、homeディレクトリはかわる
  supports :manage_home => true
  action [:create, :manage]
end

# group 
group 'nue' do
  gid 999
  members ['ubuntu','chef_user']
  action [:create, :manage]
  # 以下で追加になる
  append true
end