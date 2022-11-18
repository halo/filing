module Filing
  class Globber
    include Calls

    option :extensions

    def call(&)
      raise 'Please provide a block' unless block_given?

      # Filing.debug "Looking for extensions: #{extensions}"
      Filing.debug "Looking for patterns: #{patterns}"

      Pathname.glob(patterns.shuffle, File::FNM_CASEFOLD, &)
    end

    private

    def patterns
      extensions.map { "**/*.#{_1}" }
    end
  end
end
