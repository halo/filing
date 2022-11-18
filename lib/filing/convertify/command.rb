module Filing
  module Convertify
    class Command
      def call
        Globber.call(extensions: extensions) do |path|
          action = Convertify::Process.call(path)
          next if action == :skip

          exit if Filing::Params.step?
        end
      end

      private

      def extensions
        %w[jpg jpeg]
      end
    end
  end
end
