module Filing
  module Convertify
    module Processes
      class ConvertToHeic
        include Calls

        class NumberHelper
          include ::ActionView::Helpers::NumberHelper
        end

        param :path

        def call
          return unless do_generate_output_file
          do_transfer_timestamp

          source_size = path.size

          do_trash_source_file

          if Filing::Params.hot?
            target_size = target_path.size
            size_saved = source_size - target_size
            human_size_saved = NumberHelper.new.number_to_human_size(size_saved.abs, strip_insignificant_zeros: true)

            if size_saved.positive?
              TTY::Prompt.new.ok "    Saved #{human_size_saved}"
            else
              TTY::Prompt.new.error "    Lost #{human_size_saved}"
            end
          end
        end

        private

        def do_generate_output_file
          TTY::Prompt.new.say "  #{Pastel.new.yellow(path)} → #{Pastel.new.green(target_path)}"
          printer = Filing::Params.verbose? ? :pretty : :null
          command = TTY::Command.new(printer: printer, uuid: false, only_output_on_error: !Filing::Params.verbose?, dry_run: !Filing::Params.hot?)
          command.run(:sips, *arguments)
          true
        rescue TTY::Command::ExitError => e
          TTY::Prompt.new.error e.message
          false
        end

        def do_transfer_timestamp
          timestamp = path.mtime
          Filing.debug "    Transfering timestamp #{Pastel.new.green(timestamp.to_s)} → #{Pastel.new.yellow(target_path)}"

          unless Filing::Params.hot?
            Filing.debug "    Simulating setting modification date to #{timestamp}"
            return
          end

          Filing.debug "    Setting modification date to #{timestamp}"
          target_path.utime(timestamp, timestamp)
        end

        def do_trash_source_file
          Filing.debug "    Trashing #{Pastel.new.yellow(path)} → #{Pastel.new.yellow(trash_path)}"

          unless Filing::Params.hot?
            Filing.debug "    Simulating moving the file from #{path} to #{trash_path}"
            return
          end

          trash_path.parent.mkpath
          FileUtils.mv path, trash_path.join
        end

        def arguments
          result = []
          result.push '-s'
          result.push 'format'
          result.push 'heic'
          result.push path.to_s
          result.push '--out'
          result.push target_path.to_s
          result
        end

        def target_path
          path.parent.join path.basename.sub_ext('.heic')
        end

        def trash_path
          Pathname.new("/tmp/filing/#{Filing.execution_id}").join(path)
        end
      end
    end
  end
end
