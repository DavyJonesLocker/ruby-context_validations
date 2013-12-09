require 'test_helper'

class UsersController
  include ContextValidations::Controller

  def create
    validations
  end

  def other_create
    validations(:create)
  end

  def validate_instance_method
    validations(:validate_instance_method)
  end

  def update
    validations
  end

  def base_validations
    validates :first_name, :presence => true
  end

  def create_validations
    validates :password, :presence => true
  end

  def validate_instance_method_validations
    validate :model_validation
  end
end

class ProtectedController
  include ContextValidations::Controller

  def create
    validations(:create)
  end

  protected

  def base_validations
    validates :first_name, :presence => true
  end

  def create_validations
    validates :password, :presence => true
  end
end

class PrivateController
  include ContextValidations::Controller

  def create
    validations(:create)
  end

  private

  def base_validations
    validates :first_name, :presence => true
  end

  def create_validations
    validates :password, :presence => true
  end
end

class CustomValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value != 'awesome'
      record.errors.add(attribute, 'Failed')
    end
  end
end

class CustomValidatorsController
  include ContextValidations::Controller

  def create
    validations(:create)
  end

  private

  def base_validations
    validates :first_name, :custom => true
  end
end

describe 'Controller' do
  context 'Public validations' do
    before do
      @controller = UsersController.new
    end

    if RUBY_VERSION >= '2'
      it 'combines base and create validations for create action, context is implied' do
        @controller.create.length.must_equal 2
      end
    end

    it 'combines base and create validations for other create action, context is forced' do
      @controller.other_create.length.must_equal 2
    end

    it 'uses base validations when context validations are not set for update action' do
      @controller.update.length.must_equal 1
    end

    it 'builds validators using #validate' do
      @controller.validate_instance_method.length.must_equal 2
    end

    it 'validations built using #validate run instance methods on the model' do
      user = User.new
      user.validations = @controller.validations(:validate_instance_method)

      user.valid?.must_equal false
      user.errors[:model_validation].must_include 'Error set by instance method on model'
    end
  end

  context 'Protected validations' do
    before do
      @controller = ProtectedController.new
    end

    it 'combines base and create validations for other create action, context is forced' do
      @controller.create.length.must_equal 2
    end
  end

  context 'Private validations' do
    before do
      @controller = PrivateController.new
    end

    it 'combines base and create validations for other create action, context is forced' do
      @controller.create.length.must_equal 2
    end
  end

  context 'Custom validations' do
    before do
      @controller = CustomValidatorsController.new
    end

    it 'combines base and create validations for other create action, context is forced' do
      @controller.create.length.must_equal 1
    end
  end
end
