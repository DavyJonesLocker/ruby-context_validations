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
      if validator.options[:if]
        if validator.options[:if].respond_to?(:call)
          if validator.options[:if].call(self)
            validator.validate(self)
          end
        elsif self.send(validator.options[:if])
          validator.validate(self)
        end
      elsif validator.options[:unless]
        if validator.options[:unless].respond_to?(:call)
          if !validator.options[:unless].call(self)
            validator.validate(self)
          end
        elsif !self.send(validator.options[:unless])
          validator.validate(self)
        end
      else
        validator.validate(self)
      end
    end
    errors.empty?
  end

  private

  def _validators
    validations.inject({}) do |hash, validator|
      attribute = validator.attributes.first
      if hash.key?(attribute)
        hash[attribute] << validator
      else
        hash[attribute] = [validator]
      end
      hash
    end
  end
end
