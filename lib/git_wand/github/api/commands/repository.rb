module GitWand
  module GitHub
    module API

      module Commands
        module Repository

          def create_repository(name:, description: nil, homepage: nil, auto_init: false, private: false, license: nil)
            parameters = {
              name: name,
              private: private
            }
            parameters[:description] = description if description
            parameters[:homepage] = homepage if homepage
            parameters[:auto_init] = auto_init if auto_init
            parameters[:license] = license if license
            response = post(resource: "user/repos", parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "201"
            result.body = response[:body]
            result
          end

          def delete_repository(name:)
            response = delete(resource: "repos/#{username}/#{name}")
            result = Result.new
            result.success = response[:status][:code] == "204"
            result.body = response[:body]
            result
          end

        end
      end

    end
  end
end
