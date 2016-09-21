module GitWand
  module GitHub
    module API

      class Result

        attr_accessor :success, :body, :resource

        def success?
          @success == true
        end

      end

    end
  end
end
