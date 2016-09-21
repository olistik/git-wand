require_relative "request"
require_relative "result"
require_relative "commands/repository"
require_relative "commands/issue"
require_relative "commands/pull_request"
require_relative "commands/branch"
require_relative "commands/file"

module GitWand
  module GitHub
    module API

      extend self

      class Client
        include Commands::Repository
        include Commands::Issue
        include Commands::PullRequest
        include Commands::Branch
        include Commands::File

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

        private

          def get(resource:, query_parameters: nil)
            Request::http_request(method: :get, resource: resource, client: self, query_parameters: query_parameters)
          end

          def post(resource:, parameters: {})
            Request::http_request(method: :post, resource: resource, client: self, parameters: parameters)
          end

          def put(resource:, parameters: {})
            Request::http_request(method: :put, resource: resource, client: self, parameters: parameters)
          end

          def delete(resource:)
            Request::http_request(method: :delete, resource: resource, client: self)
          end

      end

    end
  end
end
