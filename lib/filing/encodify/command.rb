module Filing
  module Encodify
    class Command
      def call
        Globber.call(extensions: extensions) do |path|
          action = Encodify::Process.call(path)
          next if action == :skip

          exit if Filing::Params.step?
        end
      end

      private

      def extensions
        %w[mov mpg mpeg mp4 m4v]
      end
    end
  end
end
