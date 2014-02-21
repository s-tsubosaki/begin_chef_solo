#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "nginx"

notification_type = "subscribe"

case notification_type
# 実行されたリソースから、通知を使って他のリソースにアクションさせたいとき
# use notifies
when "notify"

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [:enable,:start]
end

template "nginx.conf" do
  path "/etc/nginx/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  # templateを更新したら、reloadする
  # 最近は書き方が違う
  # notifies :reload, 'service[nginx]'
  # 通常のnotificationはchefレシピ実行の最後の方になるが、:immediatelyで即時になる
  notifies :reload, resources(:service => 'nginx'), :immediately
  # notifies :run, resources(:execute => 'test-nagios-config')
end

# 実行したリソースが、トリガーとなるリソースを指定して通知してほしいとき
# use subscribes
else

template "nginx.conf" do
  # デフォルトのインストール先にならない
  path "/etc/nginx/nginx.conf"
  # nginx.conf.erbが自動選択されない
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [:enable,:start]
  # templateが更新されたら、restartする
  subscribes :restart, resources(:template => 'nginx.conf')
end

end