module ContextValidations::Controller
  def validations(context = nil)
    if RUBY_VERSION > '2'
      context ||= caller_locations(1, 1).first.label
    end
    @validations = []
    base_validations
    if respond_to?("#{context}_validations")
      send("#{context}_validations")
    end
    @validations
  end

  def validates(*attributes)
    defaults = attributes.extract_options!
    validations = defaults.slice!(*_validates_default_keys)

    attributes.inject(@validations) do |validators, attribute|
      defaults[:attributes] = [attribute]
      validations.each do |key, options|
        key = "#{key.to_s.camelize}Validator"
        klass = key.include?('::') ? key.constantize : Module.const_get("ActiveModel::Validations::#{key}")
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
