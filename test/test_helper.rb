require 'bundler/setup'

if defined?(M)
  require 'minitest/spec'
else
  require 'minitest/autorun'
end

require 'active_record'
require 'context_validations'
require 'active_model'

class MiniTest::Spec
  class << self
    alias :context :describe
  end
end

ActiveRecord::Base.establish_connection(
  :adapter => defined?(JRUBY_VERSION) ? 'jdbcsqlite3' : 'sqlite3',
  :database => ':memory:'
)
