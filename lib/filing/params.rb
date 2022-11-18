module Filing
  class Params
    include TTY::Option

    def self.hot?
      new.parse.params[:hot]
    end

    def self.problems?
      new.parse.params[:problems]
    end

    def self.verbose?
      new.parse.params[:verbose]
    end

    def self.step?
      new.parse.params[:step]
    end

    def self.year
      new.parse.params[:year]
    end

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
  end
end
