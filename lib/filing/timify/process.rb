module Filing
  module Timify
    class Process
      include Calls

      param :path, as: :raw_path

      def call
        Filing.debug "Processing #{raw_path}"

        path = raw_path
        path = Filing::Timify::Processes::NormalizeExtension.call(path)

        Filing::Timify::Processes::AddTimestamp.call(path)
      end
    end
  end
end
