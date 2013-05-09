require 'test_helper'

class UsersController
  include ContextValidations::Controller

  def create
    validations
  end

  def other_create
    validations(:create)
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
end

describe 'Controller' do
  before do
    @controller = UsersController.new
  end

  it 'combines base and create validations for create action, context is implied' do
    @controller.create.length.must_equal 2
  end

  it 'combines base and create validations for other create action, context is forced' do
    @controller.other_create.length.must_equal 2
  end

  it 'uses base validations when context validations are not set for update action' do
    @controller.update.length.must_equal 1
  end
end
