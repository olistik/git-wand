require "base64"

module GitWand
  module GitHub
    module Resource
      class IssueList

        def self.build_from_api_result(result)
          return unless result.success?
          result.body.map do |body|
            Issue.build_from_result_body(body)
          end
        end

      end
    end
  end
end
