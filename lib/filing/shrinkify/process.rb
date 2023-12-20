module Filing
  module Shrinkify
    class Process
      include Calls

      param :path

      def call
        Filing.debug "Processing #{path}"

        format = Filing::VideoFormat.new(path)

        unless format.h265?
          Filing.debug "Should not be shrunk"
          return :skip
        end

        Processes::ShrinkVideo.call(path)
      end
    end
  end
end
