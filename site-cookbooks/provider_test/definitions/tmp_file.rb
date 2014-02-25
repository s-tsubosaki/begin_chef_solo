
define :tmp_file, :user_name => nil do
  file params[:name] do
    provider Chef::Provider::File::Any
    owner params[:user_name]
    group params[:user_name]
    mode 0644
    content <<-EOC
      tmp
    EOC
    action :create
  end
end