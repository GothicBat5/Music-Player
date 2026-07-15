# frozen_string_literal: true
require "psych"
require "bundler/vendored_fileutils"
require "bundler/vendored_uri"
require "digest"

if File.expand_path(__FILE__) =~ %r{([^\w/\.:\-])}
  abort "The bundler specs cannot be run from a path that contains special characters (particularly #{$1.inspect})"
end

ENV["EDITOR"] = nil
ENV["VISUAL"] = nil
ENV["BUNDLER_EDITOR"] = nil
require "bundler"
gem "diff-lcs", "< 2.0"

require "rspec/core"
require "rspec/expectations"
require "rspec/mocks"
require "rspec/support/differ"

gem "rubygems-generate_index"
require "rubygems/indexer"

require_relative "support/builders"
require_relative "support/checksums"
require_relative "support/filters"
require_relative "support/helpers"
require_relative "support/indexes"
require_relative "support/matchers"
require_relative "support/permissions"
require_relative "support/platforms"
require_relative "support/shards"

begin
  raise LoadError if File.exist?(File.expand_path("../../lib/bundler/bundler.gemspec", __dir__))

  gem "simplecov_json_formatter"
  require "simplecov"

  SimpleCov.start do
    command_name "bundler:#{Process.pid}"
    root File.expand_path("../bundler", __dir__)
    coverage_dir File.expand_path("../coverage", __dir__)

    add_filter "/spec/"
    add_filter "/test/"
    add_filter "/lib/rubygems/"
    add_filter "/lib/bundler/vendor/"
    add_filter "/tool/"
    add_filter "/tmp/"
    add_filter ".gemspec"
    
  end

  SimpleCov.print_error_status = false
  SimpleCov.at_exit do
    $stdout = File.open(File::NULL, "w")
    SimpleCov.result.format!
  ensure
    $stdout = STDOUT
  end
rescue LoadError
end

$debug = false

module Gem
  def self.ruby=(ruby)
    @ruby = ruby
  end
end

RSpec.configure do |config|
  config.include Spec::Builders
  
  config.include Spec::Checksums
  
  config.include Spec::Helpers
  
  config.include Spec::Indexes
  
  config.include Spec::Matchers
  
  config.include Spec::Path
  
  config.include Spec::Platforms
  
  config.include Spec::Permissions

  config.include Spec::Shards
  
  config.example_status_persistence_file_path = ".rspec_status"
  
  config.silence_filter_announcements = !ENV["TEST_ENV_NUMBER"].nil?
  
  config.backtrace_exclusion_patterns <<
    %r{./spec/(spec_helper\.rb|support/.+)}

  config.disable_monkey_patching!


  config.fail_fast ||= 25 if ENV["CI"]

  config.bisect_runner = :shell

  config.expect_with :rspec do |c|
    c.syntax = :expect

    c.max_formatted_output_length = 1000
  end

  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = false
  end

  config.before :suite do
    Gem.ruby = ENV["RUBY"] if ENV["RUBY"]

    require_relative "support/rubygems_ext"
    Spec::Rubygems.test_setup


    Bundler::Retry.default_base_delay = 0


    ENV.replace(ENV.to_hash.delete_if {|k, _v| k.start_with?(Bundler::EnvironmentPreserver::BUNDLER_PREFIX) })

    ENV["BUNDLER_SPEC_RUN"] = "true"
    ENV["BUNDLE_USER_CONFIG"] = ENV["BUNDLE_USER_CACHE"] = ENV["BUNDLE_USER_PLUGIN"] = nil
    ENV["BUNDLE_APP_CONFIG"] = nil
    ENV["BUNDLE_SILENCE_ROOT_WARNING"] = nil
    ENV["RUBYGEMS_GEMDEPS"] = nil
    ENV["XDG_CONFIG_HOME"] = nil
    ENV["XDG_CACHE_HOME"] = nil
    ENV["GEMRC"] = nil

    git_version = `git --version`[/(\d+\.\d+\.\d+)/, 1]
    if Gem::Version.new(git_version) >= Gem::Version.new("2.32")
      ENV["GIT_CONFIG_GLOBAL"] = File.join(ENV["HOME"], ".gitconfig")
      ENV["GIT_CONFIG_NOSYSTEM"] = "1"
    end


    ENV["THOR_COLUMNS"] = "10000"

    extend(Spec::Builders)

    build_repo1

    reset!
  end

  config.around :each do |example|
    default_system_gems

    with_gem_path_as(system_gem_path) do
      Bundler.ui.silence { example.run }

      all_output = all_commands_output
      if example.exception && !all_output.empty?
        message = all_output + "\n" + example.exception.message
        (class << example.exception; self; end).send(:define_method, :message) do
          message
        end
      end
    end
  ensure
    
    reset!
    
  end

  Spec::Shards::EXAMPLE_MAPPINGS.each do |tag, file_paths|
    file_pattern = Regexp.union(file_paths.map {|path| Regexp.new(Regexp.escape(path) + "$") })

    config.define_derived_metadata(file_path: file_pattern) do |metadata|
      metadata[tag] = true
    end
  end

  config.before(:context) do |example|
    metadata = example.class.metadata
    if metadata[:type] != :aruba && !metadata[:realworld] && metadata.keys.none? {|k| Spec::Shards::EXAMPLE_MAPPINGS.keys.include?(k) }
      warn "#{metadata[:file_path]} is not assigned to any shard. see spec/support/shards.rb for details."
    end
  end unless Spec::Path.ruby_core?
end
