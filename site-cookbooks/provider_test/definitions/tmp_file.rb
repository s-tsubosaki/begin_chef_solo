
define :tmp_file, :user_name => nil do
  any_file params[:name] do
    owner params[:user_name]
    group params[:user_name]
    mode 0644
    content <<-EOC
      tmp
    EOC
    action :create
  end
end