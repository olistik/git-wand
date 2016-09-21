require "date"

module GitWand
  module GitHub
    module Resource
      class Issue
        attr_accessor :html_url, :number, :state, :title, :body, :user, :labels, :assignee, :locked, :comments_count, :pull_request_reference, :created_at, :updated_at, :closed_at

        def self.build_from_api_result(result)
          return unless result.success?
          resource = build_from_result_body(result.body)
        end

        def self.build_from_result_body(result_body)
          resource = new
          resource.html_url = result_body["html_url"]
          resource.number = result_body["number"]
          resource.state = result_body["state"]
          resource.locked = result_body["locked"]
          resource.title = result_body["title"]
          resource.body = result_body["body"]
          resource.user = result_body["user"] # TODO: convert into a User resource
          resource.labels = result_body["labels"] # TODO: convert into a Label resource
          resource.assignee = result_body["assignee"] # TODO: convert into a User resource
          resource.comments_count = result_body["comments"]
          resource.pull_request_reference = result_body["pull_request"]
          resource.created_at = convert_datetime(result_body["created_at"])
          resource.updated_at = convert_datetime(result_body["updated_at"])
          resource.closed_at = convert_datetime(result_body["closed_at"])
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
