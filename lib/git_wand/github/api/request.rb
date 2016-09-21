require "set"
require "net/http"
require_relative "response"

module GitWand
  module GitHub
    module API

      module Request

        extend self

        API_DOMAIN = "https://api.github.com"

        ALLOWED_HTTP_METHODS = %i[get post head put delete options trace patch].to_set

        def http_request(resource:, method: :get, client:, parameters: {}, query_parameters: nil)
          if ALLOWED_HTTP_METHODS.include?(method)
            net_http_class = Net::HTTP.const_get(method.to_s.capitalize.to_sym)
          else
            # TODO: raise a proper error
            raise "#{method} is not a valid HTTP method"
          end

          uri = build_resource_uri(resource)
          if query_parameters
            uri.query = URI.encode_www_form(query_parameters)
          end
          response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
            request = net_http_class.new(uri)
            request["Accept"] = "application/vnd.github.v3+json"
            request["Content-Type"] = "application/json"
            request.basic_auth(client.username, client.token)
            request.body = JSON.generate(parameters)
            http.request(request)
          end
          Response.parse(response)
        end

        def build_resource_uri(resource)
          URI("#{API_DOMAIN}/#{resource}")
        end

      end

    end
  end
end
