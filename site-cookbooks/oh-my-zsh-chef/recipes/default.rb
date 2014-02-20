#
# Cookbook Name:: oh_my_zsh
# Recipe:: default
#

is_mac_os = node[:platform] =~ /mac/

if node['oh_my_zsh']['users'].any?
  if is_mac_os
    include_recipe 'homebrew'
  end
  package "zsh"
  package "git"
end

# for each listed user
user_ids = data_bag('users')
user_ids.each do |id|
  user_hash = data_bag_item('users',id)
  next if user_hash.nil?

  user_name = id
  user_setting = user_hash['oh-my-zsh']

  # ohai情報にuser_nameがある場合のみ
  if node[:etc][:passwd].key?(user_name)
    home_directory = node[:etc][:passwd][user_name][:dir]

    log "process user=#{user_name}, home=#{home_directory}"
    log "user_hash=#{user_setting}"

    git "#{home_directory}/.oh-my-zsh" do
      repository 'https://github.com/robbyrussell/oh-my-zsh.git'
      user user_name
      reference "master"
      action :sync
    end

    # rbenv環境がある?
    has_rbenv = `ls -la #{home_directory} | grep .rbenv`
    if has_rbenv.length > 0 
      log "rbenv found"
    end

    template "#{home_directory}/.zshrc" do
      source "zshrc.erb"
      owner user_name
      mode "644"
      action :create
      #action :create_if_missing
      variables({
        :user => user_name,
        :theme => user_setting['theme'] || 'robbyrussell',
        :case_sensitive => user_setting['case_sensitive'] || false,
        :plugins => user_setting['plugins'] || %w(git),
        :use_rbenv => has_rbenv.length > 0 ? 1 : 0
      })
    end

    user user_name do
      action :modify
      shell '/bin/zsh'
    end

    if !is_mac_os
      execute "source /etc/profile to all zshrc" do
        command "echo 'source /etc/profile' >> /etc/zsh/zprofile"
        not_if "grep 'source /etc/profile' /etc/zsh/zprofile"
      end
    end

  end  
end
