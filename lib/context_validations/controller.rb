module ContextValidations::Controller
  # Will build the validations used to assign to a model instance
  #
  # Passing a context will call the `#{context}_validations` method if available
  # `#base_validations` will always be called prior to `#{context}_validations`
  #
  # If you are using Ruby 2.0+ not passing a context will force an implicit context call
  # based upon the calling method name.
  #
  # examples:
  #   # Implicit method call will call `#base_validations` then `#create_validations`
  #   def create
  #     @user.validations = validations
  #   end
  #
  #   # Will call `#base_validations` then `#create_validations`
  #   def other_create
  #     @user.validations = validations(:create)
  #   end
  #
  #   # Will onliy call `#base_validations` because `#update_validations` does not exist
  #   def update
  #     @user.validations = validations
  #   end
  #
  #   def create_validations
  #     ...
  #   end
  #
  # @param [String, Symbol]
  def validations(context = nil)
    if RUBY_VERSION > '2'
      context ||= caller_locations(1, 1).first.label
    end
    @validations = []
    base_validations
    if respond_to?("#{context}_validations") || private_methods.include?("#{context}_validations".to_sym) ||
      protected_methods.include?("#{context}_validations".to_sym)
      send("#{context}_validations")
    end
    @validations
  end

  # Instance level implementation of `ActiveModel::Validations.validates`
  # Will accept all of the same options as the class-level model versions of the method
  def validates(*attributes)
    defaults = attributes.extract_options!
    validations = defaults.slice!(*_validates_default_keys)

    attributes.inject(@validations) do |validators, attribute|
      defaults[:attributes] = [attribute]
      validations.each do |key, options|
        key = "#{key.to_s.camelize}Validator"
        namespace = defined?(ActiveRecord) ? 'ActiveRecord::Base' : 'ActiveModel::Validations'
        klass = key.include?('::') ? key.constantize : "#{namespace}::#{key}".constantize
        validator = klass.new(defaults.merge(_parse_validates_options(options)))
        validators << validator
      end
      validators
    end.flatten.uniq
  end

  private

  def _validates_default_keys
    [:if, :unless, :on, :allow_blank, :allow_nil , :strict]
  end

  def _parse_validates_options(options)
    case options
    when TrueClass
      {}
    when Hash
      options
    when Range, Array
      { :in => options }
    else
      { :with => options }
    end
  end
end
