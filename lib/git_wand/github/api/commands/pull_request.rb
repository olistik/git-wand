module GitWand
  module GitHub
    module API

      module Commands
        module PullRequest

          # List pull requests
          # https://developer.github.com/v3/pulls/#list-pull-requests
          # GET /repos/:owner/:repo/pulls
          # Parameters
          # | Name | Type | Description |
          # |------|------|-------------|
          # | state | string | Either open, closed, or all to filter by state. Default: open |
          # | head | string | Filter pulls by head user and branch name in the format of user:ref-name. Example: github:new-script-format. |
          # | base | string | Filter pulls by base branch name. Example: gh-pages. |
          # | sort | string | What to sort results by. Can be either created, updated, popularity (comment count) or long-running (age, filtering by pulls updated in the last month). Default: created |
          # | direction | string | The direction of the sort. Can be either asc or desc. Default: desc when sort is created or sort is not specified, otherwise asc. |
          def list_pull_requests(owner:, repo:, state: nil, head: nil, base: nil, sort: nil, direction: nil)
            parameters = {
            }
            parameters[:state] = state if state
            parameters[:head] = head if head
            parameters[:base] = base if base
            parameters[:sort] = sort if sort
            parameters[:direction] = direction if direction
            response = get(resource: "repos/#{owner}/#{repo}/pulls", query_parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "200"
            result.body = response[:body]
            result.resource = Resource::PullRequestList.build_from_api_result(result)
            result
          end

          def get_pull_request(owner:, repo:, number:)
            response = get(resource: "repos/#{owner}/#{repo}/pulls/#{number}")
            result = Result.new
            result.success = response[:status][:code] == "200"
            result.body = response[:body]
            result.resource = Resource::PullRequest.build_from_api_result(result)
            result
          end

          # https://developer.github.com/v3/pulls/#create-a-pull-request
          # | Name  | Type   | Description |
          # |-------|--------|-------------|
          # | title | string | *Required.* The title of the pull request. |
          # | head  | string | *Required.* The name of the branch where your changes are implemented. For cross-repository pull requests in the same network, namespace head with a user like this: username:branch. |
          # | base  | string | *Required.* The name of the branch you want the changes pulled into. This should be an existing branch on the current repository. You cannot submit a pull request to one repository that requests a merge to a base of another repository. |
          # | body  | string | The contents of the pull request. |
          def create_pull_request(owner:, repo:, title:, head:, base:, body:)
            parameters = {
              title: title,
              head: head,
              base: base,
              body: body,
            }
            raw_create_pull_request(owner: owner, repo: repo, parameters: parameters)
          end

          def create_pull_request_from_issue(owner:, repo:, head:, base:, issue:)
            parameters = {
              head: head,
              base: base,
              issue: issue,
            }
            raw_create_pull_request(owner: owner, repo: repo, parameters: parameters)
          end

          def raw_create_pull_request(owner:, repo:, parameters:)
            response = post(resource: "repos/#{owner}/#{repo}/pulls", parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "201"
            result.body = response[:body]
            result.resource = Resource::PullRequest.build_from_api_result(result)
            result
          end

          # TODO
          # Update a PR
          # PATCH /repos/:owner/:repo/pulls/:number
          # | Name  | Type   | Description |
          # |-------|--------|-------------|
          # | title | string | The title of the pull request. |
          # | body  | string | The contents of the pull request. |
          # | state | string | State of this Pull Request. Either open or closed. |
          # | base  | string | The name of the branch you want your changes pulled into. This should be an existing branch on the current repository. You cannot update the base branch on a pull request to point to another repository. |

          # url: https://developer.github.com/v3/pulls/#update-a-pull-request

          # TODO
          # Get if a pull request has been merged
          # GET /repos/:owner/:repo/pulls/:number/merge
          # is merged: 204
          # is not merged: 404

          # url: https://developer.github.com/v3/pulls/#get-if-a-pull-request-has-been-merged

          # Merge a PR
          # url: https://developer.github.com/v3/pulls/#merge-a-pull-request-merge-button
          # PUT /repos/:owner/:repo/pulls/:number/merge
          # | Name | Type | Description |
          # |------|------|-------------|
          # | commit_message | string | Extra detail to append to automatic commit message. |
          # | sha | string | SHA that pull request head must match to allow merge |

          # Response if merge was successful: 200
          # Response if merge cannot be performed: 405
          # Response if sha was provided and pull request head did not match: 409
          def merge_pull_request(owner:, repo:, number:, message:, squash: false)
            result = get_pull_request(owner: owner, repo: repo, number: number)
            pull_request = result.resource
            # TODO: handle errors while retrieving the resource
            parameters = {
              commit_message: message,
              sha: pull_request.head_sha,
              squash: squash,
            }
            response = put(resource: "repos/#{owner}/#{repo}/pulls/#{number}/merge", parameters: parameters)
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
