module ContextValidations::Model
  def self.included(base)
    base.class_eval do
      reset_callbacks(:validate)
    end

    base._validators.keys.each do |key|
      base._validators.delete(key)
    end
  end

  def validations
    @validations ||= []
  end

  def validations=(validations)
    @validations = validations.flatten
  end

  protected

  def run_validations!
    Array.wrap(validations).each do |validator|
      validator.validate(self)
    end
    errors.empty?
  end
end
