module Filing
  module Shrinkify
    class Command
      def call
        if Params.pathnames.empty?
          TTY::Prompt.new.error('You must specify at least one path')
          exit 3
        end

        Params.pathnames.each do |path|
          action = Shrinkify::Process.call(path)
          next if action == :skip
        end
      end
    end
  end
end
