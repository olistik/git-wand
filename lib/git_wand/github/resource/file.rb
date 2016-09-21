require "base64"

module GitWand
  module GitHub
    module Resource
      class File
        attr_accessor :content, :name, :path, :sha, :size, :html_url

        def self.build_from_api_result(result)
          return unless result.success?
          resource = new
          resource.name = result.body["name"]
          resource.path = result.body["path"]
          resource.sha = result.body["sha"]
          resource.size = result.body["size"]
          resource.html_url = result.body["html_url"]
          resource.content = Base64::decode64(result.body["content"])
          resource
        end

      end
    end
  end
end
