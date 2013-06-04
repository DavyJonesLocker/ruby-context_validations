module ContextValidations::Model
  def self.included(base)
    base.class_eval do
      reset_callbacks(:validate)
    end

    base._validators.keys.each do |key|
      base._validators.delete(key)
    end
  end

  # The collection of validations assigned to this model instance
  #
  # @return [Array]
  def validations
    @validations ||= []
  end

  # Use to set the validations collection assigned to this model instance
  #
  # Pass an array of validator instances
  #
  # @param [[ActiveMode::Validations::Validator]]
  def validations=(validations)
    @validations = validations.flatten
  end

  protected

  def run_validations!
    Array.wrap(validations).each do |validator|
      if validator.respond_to?(:setup)
        validator.setup(self.class)
      end
      validator.validate(self)
    end
    errors.empty?
  end
end
