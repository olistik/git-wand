require "date"

module GitWand
  module GitHub
    module Resource
      class PullRequest
        attr_accessor :html_url, :issue_url, :number, :state, :locked, :title, :user, :body, :created_at, :updated_at, :closed_at, :merged_at, :head_sha

        def self.build_from_api_result(result)
          return unless result.success?
          resource = build_from_result_body(result.body)
        end

        def self.build_from_result_body(result_body)
          resource = new
          resource.html_url = result_body["html_url"]
          resource.issue_url = result_body["issue_url"]
          resource.number = result_body["number"]
          resource.title = result_body["title"]
          resource.state = result_body["state"]
          resource.locked = result_body["locked"]
          resource.body = result_body["body"]
          resource.created_at = convert_datetime(result_body["created_at"])
          resource.updated_at = convert_datetime(result_body["updated_at"])
          resource.closed_at = convert_datetime(result_body["closed_at"])
          resource.merged_at = convert_datetime(result_body["merged_at"])
          resource.head_sha = result_body["head"]["sha"]
          resource
        end

        def open?
          self.state == "open"
        end

        def closed?
          self.state == "closed"
        end

        private

          def self.convert_datetime(value)
            value && DateTime.parse(value)
          end

      end
    end
  end
end
