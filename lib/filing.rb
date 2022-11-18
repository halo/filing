require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'actionview'
  gem 'calls'
  gem 'exiftool'
  gem 'pastel'
  gem 'tty-command'
  gem 'tty-option'
  gem 'tty-prompt'
  gem 'warning'
end

require 'action_view'
require 'fileutils'

Dir[File.join(__dir__, 'filing/**/*.rb')].each { require _1 }

module Filing
  def self.debug(message)
    TTY::Prompt.new.say(Pastel.new.dim(message)) if Filing::Params.verbose?
  end

  def self.execution_id
    @uuid ||= Time.now.to_i
  end
end
