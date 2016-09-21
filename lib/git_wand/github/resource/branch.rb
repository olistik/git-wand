module GitWand
  module GitHub
    module Resource
      class Branch
        attr_accessor :name, :commit

        def self.build_from_api_result(result)
          return unless result.success?
          resource = new
          resource.name = result.body["name"]
          resource.commit = result.body["commit"]
          resource
        end

      end
    end
  end
end
