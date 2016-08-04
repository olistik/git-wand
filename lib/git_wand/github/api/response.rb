require "json"

module GitWand
  module GitHub
    module API

      module Response
        extend self

        def parse(response)
          {
            body: parse_body(response),
            status: parse_status(response)
          }
        end

        private

          def parse_body(response)
            if response.body
              JSON.parse(response.body)
            else
              {}
            end
          end

          def parse_status(response)
            {
              code: response.code,
              description: response.to_hash["status"].join(",")
            }
          end
      end

    end
  end
end
