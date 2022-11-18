module Filing
  class Rename
    include Calls

    option :from
    option :to

    def call
      Filing.debug "  RENAME #{from} → #{to}"

      raise "I only rename files inside the same directory. Compare #{from} with #{to}" unless from.dirname.to_s == to.dirname.to_s

      if from.to_s.downcase == to.to_s.downcase
        Filing.debug '  Ignoring case-insensitive identical filename'
        return from
      end

      return from unless Filing::Params.hot?

      FileUtils.mv from, to

      return to
    end

    private
  end
end
