module Filing
  module Encodify
    class Process
      include Calls

      param :path

      def call
        Filing.debug "Processing #{path}"

        format = Filing::VideoFormat.new(path)

        unless format.h264? || format.mpeg1? || format.mpeg4? || format.avc?
          Filing.debug "Needs no conversion"
          return :skip
        end

        Processes::ConvertToHevc.call(path)
      end
    end
  end
end
