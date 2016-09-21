module GitWand
  module GitHub
    module API

      module Commands
        module Branch

          # Get Branch
          # https://developer.github.com/v3/repos/branches/#get-branch
          # GET /repos/:owner/:repo/branches/:branch
          def get_branch(owner:, repo:, branch:)
            response = get(resource: "repos/#{owner}/#{repo}/branches/#{branch}")
            result = Result.new
            result.success = response[:status][:code] == "200"
            result.body = response[:body]
            result.resource = Resource::Branch.build_from_api_result(result)
            result
          end

          def create_branch(owner:, repo:, dest_branch:, source_branch:)
            result = get_branch(owner: owner, repo: repo, branch: source_branch)
            branch = result.resource
            # TODO: handle errors while retrieving the resource
            parameters = {
              ref: "refs/heads/#{dest_branch}",
              sha: branch.commit["sha"]
            }
            response = post(resource: "repos/#{owner}/#{repo}/git/refs", parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "201"
            result.body = response[:body]
            result
          end

          # Delete a Reference
          # https://developer.github.com/v3/git/refs/#delete-a-reference
          # Example: Deleting a branch:
          # DELETE /repos/octocat/Hello-World/git/refs/heads/feature-a
          def delete_branch(owner:, repo:, branch:)
            response = delete(resource: "repos/#{owner}/#{repo}/git/refs/heads/#{branch}")
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
