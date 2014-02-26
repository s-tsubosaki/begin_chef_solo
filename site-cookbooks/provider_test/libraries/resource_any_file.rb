class Chef
  class Resource
    class AnyFile < Chef::Resource::File
      def initialize(name, run_context=nil)
        super
        @provider = Chef::Provider::File::Any
      end
    end
  end
end