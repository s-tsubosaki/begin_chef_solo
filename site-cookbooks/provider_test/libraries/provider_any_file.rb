require 'chef/log'

class Chef
  class Provider
    class File 
      class Any < Chef::Provider::File
        def action_create
          Chef::Log.info "AnyFile action_create called."
          super
        end
      end
    end
  end
end