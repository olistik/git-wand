require "base64"

module GitWand
  module GitHub
    module API

      module Commands
        module File

          # Get contents
          # This method returns the contents of a file or directory in a repository.
          #
          # GET /repos/:owner/:repo/contents/:path
          #
          # | Name | Type | Description |
          # |------|------|-------------|
          # | path | string | The content path. |
          # | ref | string | The name of the commit/branch/tag. Default: the repository’s default branch (usually master) |
          # b8b0a4b3d8dfa9a571353a5c29a9963110d32856
          def get_file(owner:, repo:, path:, ref:)
            parameters = {
              ref: ref
            }
            response = get(resource: "repos/#{owner}/#{repo}/contents/#{path}", query_parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "200"
            result.body = response[:body]
            result.resource = Resource::File.build_from_api_result(result)
            result
          end

          # Update a file
          # PUT /repos/:owner/:repo/contents/:path
          # | Name | Type | Description |
          # |------|------|-------------|
          # | path | string | Required. The content path. |
          # | message | string | Required. The commit message. |
          # | content | string | Required. The updated file content, Base64 encoded. |
          # | sha | string | Required. The blob SHA of the file being replaced. |
          # | branch | string | The branch name. Default: the repository’s default branch (usually master) |
          def update_file(owner:, repo:, path:, message:, content:, branch:)
            result = get_file(owner: owner, repo: repo, path: path, ref: branch)
            # TODO: handle errors while retrieving the resource
            sha = result.body["sha"]
            parameters = {
              message: message,
              content: Base64::encode64(content),
              sha: sha,
              branch: branch,
            }
            response = put(resource: "repos/#{owner}/#{repo}/contents/#{path}", parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "200"
            result.body = response[:body]
            result
          end

          def create_file(owner:, repo:, path:, message:, content:, branch:)
            parameters = {
              message: message,
              content: Base64::encode64(content),
              branch: branch,
            }
            response = put(resource: "repos/#{owner}/#{repo}/contents/#{path}", parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "201"
            result.body = response[:body]
            result
          end

          # Delete a file
          # This method deletes a file in a repository
          #
          # DELETE /repos/:owner/:repo/contents/:path
          #
          # | Name | Type | Description |
          # |------|------|-------------|
          # | path | string | Required. The content path. |
          # | message | string | Required. The commit message. |
          # | sha | string | Required. The blob SHA of the file being replaced. |
          # | branch | string | The branch name. Default: the repository’s default branch (usually master) |
          def delete_file(owner:, repo:, path:, message:, branch:)
            result = get_file(owner: owner, repo: repo, path: path, ref: branch)
            # TODO: handle errors while retrieving the resource
            sha = result.body["sha"]
            parameters = {
              message: message,
              sha: sha,
              branch: branch,
            }
            response = delete(resource: "repos/#{owner}/#{repo}/contents/#{path}", parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "200"
            result.body = response[:body]
            result
          end

        end
      end

    end
  end
end
