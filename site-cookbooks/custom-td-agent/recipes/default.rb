#
# Cookbook Name:: td-agent
# Recipe:: default
#
# Copyright 2011, Treasure Data, Inc.
#

log "custom-td-agent run"

# グループ作成
group 'td-agent' do
  group_name 'td-agent'
  gid        403
  action     [:create]
end

# ユーザー作成
# password nil, shell /bin/falseでログインできないユーザーになる
user 'td-agent' do
  comment  'td-agent'
  uid      403
  group    'td-agent'
  home     '/var/run/td-agent'
  shell    '/bin/false'
  password nil
  # Is set false, usermod do not pass -dm
  supports :manage_home => false
  action   [:create, :manage]
end

# ディレクトリ作成
directory '/etc/td-agent/' do
  owner  'td-agent'
  group  'td-agent'
  mode   '0755'
  action :create
end

# td-agentはサードパーティ製なので、外部リポジトリの設定
case node['platform']
when "ubuntu"
  dist = node['lsb']['codename']
  source = (dist == 'precise') ? "http://packages.treasure-data.com/precise/" : "http://packages.treasure-data.com/debian/"
  apt_repository "treasure-data" do
    uri source
    distribution dist
    components ["contrib"]
    action :add
  end
when "centos", "redhat"
  yum_repository "treasure-data" do
    url "http://packages.treasure-data.com/redhat/$basearch"
    gpgkey "http://packages.treasure-data.com/redhat/RPM-GPG-KEY-td-agent"
    action :add
  end
end

# 設定ファイルをテンプレートから生成
template "/etc/td-agent/td-agent.conf" do
  mode "0644"
  source "td-agent.conf.erb"
end

# 追加conf設定があれば
if node['td_agent']['includes']
  directory "/etc/td-agent/conf.d" do
    mode "0755"
  end
end

# td-agentのインストール
package "td-agent" do
  # platform別オプションの設定
  options value_for_platform(
    ["ubuntu", "debian"] => {"default" => "-f --force-yes"},
    "default" => nil
  )
  # :install => インストールされてたら、スキップする
  # :upgrade => 更新があったら、再インストール
  action :upgrade
end

# OSのサービスに追加したり、起動したり
service "td-agent" do
  # :enable => サービスの追加
  # :start => 起動
  action [ :enable, :start ]
  # templateが更新されてたら、再起動しなさい
  subscribes :restart, resources(:template => "/etc/td-agent/td-agent.conf")
end

node[:td_agent][:plugins].each do |plugin|
  if plugin.is_a?(Hash)
    plugin_name, plugin_attributes = plugin.first
    td_agent_gem plugin_name do
      plugin true
      %w{action version source options gem_binary}.each do |attr|
        send(attr, plugin_attributes[attr]) if plugin_attributes[attr]
      end
    end
  elsif plugin.is_a?(String)
    td_agent_gem plugin do
      plugin true
    end
  end
end
