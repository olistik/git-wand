module GitWand
  module GitHub
    module API

      module Commands
        module Issue

          # List issues for a repository
          # GET /repos/:owner/:repo/issues
          # https://developer.github.com/v3/issues/#list-issues-for-a-repository
          # Parameters
          # | Name | Type | Description |
          # |------|------|-------------|
          # | milestone | integer or string | If an integer is passed, it should refer to a milestone by its number field. If the string * is passed, issues with any milestone are accepted. If the string none is passed, issues without milestones are returned. |
          # | state | string | Indicates the state of the issues to return. Can be either open, closed, or all. Default: open |
          # | assignee | string | Can be the name of a user. Pass in none for issues with no assigned user, and * for issues assigned to any user. |
          # | creator | string | The user that created the issue. |
          # | mentioned | string | A user that's mentioned in the issue. |
          # | labels | string | A list of comma separated label names. Example: bug,ui,@high |
          # | sort | string | What to sort results by. Can be either created, updated, comments. Default: created |
          # | direction | string | The direction of the sort. Can be either asc or desc. Default: desc |
          # | since | string | Only issues updated at or after this time are returned. This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. |
          def list_repository_issues(owner:, repo:, milestone: nil, state: nil, assignee: nil, creator: nil, mentioned: nil, labels: [], sort: :created, direction: :desc, since: nil)
            parameters = {}
            parameters[:milestone] = milestone if milestone
            parameters[:state] = state if state
            parameters[:assignee] = assignee if assignee
            parameters[:creator] = creator if creator
            parameters[:mentioned] = mentioned if mentioned
            parameters[:labels] = labels.join(",") if labels.any?
            parameters[:sort] = sort if sort
            parameters[:direction] = direction if direction
            parameters[:since] = since if since
            response = get(resource: "repos/#{owner}/#{repo}/issues", query_parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "200"
            result.body = response[:body]
            result.resource = Resource::IssueList.build_from_api_result(result)
            result
          end

          # Get a single issue
          # https://developer.github.com/v3/issues/#get-a-single-issue
          # GET /repos/:owner/:repo/issues/:number
          def get_issue(owner:, repo:, number:)
            response = get(resource: "repos/#{owner}/#{repo}/issues/#{number}")
            result = Result.new
            result.success = response[:status][:code] == "200"
            result.body = response[:body]
            result.resource = Resource::Issue.build_from_api_result(result)
            result
          end

          # Create an issue
          # Any user with pull access to a repository can create an issue.
          #
          # POST /repos/:owner/:repo/issues
          #
          # Parameters
          # | Name | Type | Description |
          # |------|------|-------------|
          # | title | string | Required. The title of the issue. |
          # | body | string | The contents of the issue. |
          # | assignee | string | Login for the user that this issue should be assigned to. NOTE: Only users with push access can set the assignee for new issues. The assignee is silently dropped otherwise. This field is deprecated. |
          # | milestone | integer | The number of the milestone to associate this issue with. NOTE: Only users with push access can set the milestone for new issues. The milestone is silently dropped otherwise. |
          # | labels | array | of strings	Labels to associate with this issue. NOTE: Only users with push access can set labels for new issues. Labels are silently dropped otherwise. |
          # | assignees | array | of strings	Logins for Users to assign to this issue. NOTE: Only users with push access can set assignees for new issues. Assignees are silently dropped otherwise. |

          def create_issue(owner:, repo:, title:, body:)
            parameters = {
              title: title,
              body: body,
            }
            response = post(resource: "repos/#{owner}/#{repo}/issues", parameters: parameters)
            result = Result.new
            result.success = response[:status][:code] == "201"
            result.body = response[:body]
            result.resource = Resource::Issue.build_from_api_result(result)
            result
          end

        end
      end

    end
  end
end
