require 'context_validations/version'
require 'active_support'
if defined?(MiniTest::Unit::TestCase)
  require 'context_validations/minitest'
end

module ContextValidations
  extend ActiveSupport::Autoload

  autoload :Controller
  autoload :Model
end
