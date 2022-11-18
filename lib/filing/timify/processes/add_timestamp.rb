module Filing
  module Timify
    module Processes
      class AddTimestamp
        include Calls

        param :path

        def call
          if path.basename.to_s.start_with?(/\d{4}-\d{2}-\d{2} /)
            Filing.debug '  Already starts with a date.'
            return :skip
          end

          time = Filing::CreationTime.call(path)

          unless time
            TTY::Prompt.new.error(path)
            return
          end

          prefix = time.strftime('%Y-%m-%d %H-%M-%S')
          normalized_filename = path.basename.sub_ext(path.extname.to_s.downcase.strip)
          new_path = path.parent.join "#{prefix} #{normalized_filename}"


          TTY::Prompt.new.say "#{Pastel.new.yellow(path)}  →  #{Pastel.new.green(new_path)}"

          Filing::Rename.call(from: path, to: new_path)
        end
      end
    end
  end
end
