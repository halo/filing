module Filing
  class Params
    include TTY::Option

    def self.hot?
      parse.params[:hot]
    end

    def self.problems?
      parse.params[:problems]
    end

    def self.verbose?
      parse.params[:verbose]
    end

    def self.step?
      parse.params[:step]
    end

    def self.year
      parse.params[:year]
    end

    def self.paths
      parse.params[:paths]
    end

    def self.pathnames
      candidates = Array(paths).map { ::Pathname.new(_1).expand_path }
      return candidates if candidates.all?(&:file?)

      missing_path = candidates.detect { !_1.file? }
      TTY::Prompt.new.error("File not found: #{missing_path}")
      exit 4
    end

    def self.parse
      new.parse(raise_on_parse_error: true)
    rescue TTY::Option::InvalidParameter, TTY::Option::InvalidArity => ex
      TTY::Prompt.new.error(ex.message)
      exit 2
    end
    private_class_method :parse

    flag :hot do
      long '--hot'
      desc 'Actually perform file operations'
    end

    flag :verbose do
      long '--verbose'
      desc 'Show verbose debugging output'
    end

    flag :problems do
      long '--problems'
      desc 'Compact output, only showing problematic files'
    end

    flag :step do
      long "--step"
      desc "Only process one file"
    end

    option :year do
      long "--year int"
      desc "A reference year to cross-reference time metadata"
    end

    argument :paths do
      optional
      arity :any
      desc "Path to a file"
    end
  end
end
