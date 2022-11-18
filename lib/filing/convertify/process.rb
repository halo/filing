module Filing
  module Convertify
    class Process
      include Calls

      param :path

      def call
        Filing.debug "Processing #{path}"

        format = Filing::ImageFormat.new(path)

        unless format.jpeg?
          Filing.debug "Needs no conversion."
          return :skip
        end

        Processes::ConvertToHeic.call(path)
      end
    end
  end
end
