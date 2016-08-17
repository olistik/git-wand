require_relative "request"
require_relative "result"

module GitWand
  module GitHub
    module API

      extend self

      class Client
        attr_reader :username, :token

        def initialize(username:, token:)
          @username = username
          @token = token
        end

        def current_user_info
          response = get(resource: "user")
          result = Result.new
          result.success = response[:status][:code] == "200"
          result.body = response[:body]
          result
        end

        def create_repository(name:, private: false)
          parameters = {
            name: name,
            private: private
          }
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

        private

          def get(resource:)
            Request::http_request(method: :get, resource: resource, client: self)
          end

          def post(resource:, parameters: {})
            Request::http_request(method: :post, resource: resource, client: self, parameters: parameters)
          end

          def delete(resource:)
            Request::http_request(method: :delete, resource: resource, client: self)
          end

      end

    end
  end
end
