require 'bundler/setup'

if defined?(M)
  require 'minitest/spec'
else
  require 'minitest/autorun'
end

require 'context_validations'

class MiniTest::Spec
  class << self
    alias :context :describe
  end
end
