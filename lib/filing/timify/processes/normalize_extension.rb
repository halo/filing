module Filing
  module Timify
    module Processes
      class NormalizeExtension
        include Calls

        param :path

        def call
          if path == new_path
            Filing.debug "  Extension `#{normalized_current_extension}` is fine."
            return path
          end

          Filing::Rename.call(from: path, to: new_path)
        end

        private

        def new_path
          path.parent.join(new_filename)
        end

        def new_filename
          path.basename.sub_ext(normalized_new_extension)
        end

        def normalized_current_extension
          path.extname.to_s.downcase.strip
        end

        # Do not add `mpg`, because we don't know if its MPEG-1 or MPEG-4
        def normalized_new_extension
          case normalized_current_extension
          when '.jpeg' then '.jpg'
          when '.mov' then '.mp4'
          when '.m4v' then '.mp4'
          else normalized_current_extension
          end
        end
      end
    end
  end
end
