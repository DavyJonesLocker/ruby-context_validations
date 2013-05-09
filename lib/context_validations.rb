require 'context_validations/version'
require 'active_support'

module ContextValidations
  extend ActiveSupport::Autoload

  autoload :Controller
  autoload :Model
end
