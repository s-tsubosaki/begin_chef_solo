# define resource

require 'json'

define :cpanm, :force => nil, :user_name => nil, :home_directory => nil do

  user_name = params[:user_name] || node[:current_user]
  home_directory = params[:home_directory] || node[:etc][:passwd][node[:current_user]][:dir]

  # paramsをダンプしてみる
  file "/tmp/cpanm.param.json" do
    owner user_name
    group user_name
    mode 0644
    content <<-EOC
      #{JSON.pretty_generate(params)}
    EOC
    action :create
  end

  include_recipe 'script_execute::perlbrew'

  # perlbrewを使ってcpanmをインストール
  bash "install cpanm" do
    code <<-EOC
      source ~/perl5/perlbrew/etc/bashrc
      perlbrew install-cpanm
    EOC
    not_if "which cpanm"
  end

  # cpanmを使ってparlモジュールをインストール
  bash "install-#{params[:name]}" do
    user user_name
    cwd home_directory
    environment "HOME" => home_directory

    if params[:force]
      code <<-EOC
        source ~/perl5/perlbrew/etc/bashrc
        cpanm --force #{params[:name]}
      EOC
    else
      code <<-EOC
        source ~/perl5/perlbrew/etc/bashrc
        cpanm #{params[:name]}
      EOC
    end

    not_if <<-EOC, :user => user_name, :environment => { 'HOME' => home_directory }
      source ~/perl5/perlbrew/etc/bashrc && perl -m#{params[:name]} -e ''
    EOC
  end

end