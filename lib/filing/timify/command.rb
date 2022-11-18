module Filing
  module Timify
    class Command
      def call
        Globber.call(extensions: extensions) do |path|
          action = Timify::Process.call(path)
          next if action == :skip

          exit if Filing::Params.step?
        end
      end

      private

      def extensions
        %w[jpg jpeg heic hevc mov mpg mpeg mp4 m4v]
      end
    end
  end
end
