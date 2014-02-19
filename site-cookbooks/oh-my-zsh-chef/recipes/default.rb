#
# Cookbook Name:: oh_my_zsh
# Recipe:: default
#

is_mac_os = node[:platform] =~ /mac/

if node['oh_my_zsh']['users'].any?
  if is_mac_os
    include_recipe 'homebrew'
    package "zsh" do
      provider Chef::Provider::Package::Homebrew
    end
    package "git" do
      provider Chef::Provider::Package::Homebrew
    end
  else
    package "zsh"
    package "git"
  end
end

# for each listed user
node['oh_my_zsh']['users'].each do |user_hash|
  user_name = user_hash[:login]

  # ohai情報にuser_nameがある場合のみ
  if node[:etc][:passwd].key?(user_name)
    home_directory = node[:etc][:passwd][user_name][:dir]

    log "process user=#{user_name}, home=#{home_directory}"

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
      owner user_hash[:login]
      mode "644"
      action :create
      #action :create_if_missing
      variables({
        :user => user_hash[:login],
        :theme => user_hash[:theme] || 'robbyrussell',
        :case_sensitive => user_hash[:case_sensitive] || false,
        :plugins => user_hash[:plugins] || %w(git),
        :use_rbenv => has_rbenv.length > 0 ? 1 : 0
      })
    end

    user user_hash[:login] do
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
