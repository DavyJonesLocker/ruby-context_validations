require 'test_helper'

EmailFormat = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/

users_table = %{CREATE TABLE users (id INTEGER PRIMARY KEY, first_name TEXT, email TEXT);}
ActiveRecord::Base.connection.execute(users_table)
class User < ActiveRecord::Base
  include ContextValidations::Model

  validates :first_name, :presence => true
  validates :email, :format => EmailFormat
end

describe 'Model' do
  before do
    @user = User.new
  end

  it 'ignores existing validations' do
    @user.valid?.must_equal true
  end

  it 'accepts validations set onto the instance' do
    validations = [ActiveModel::Validations::PresenceValidator.new(:attributes => [:first_name]), ActiveModel::Validations::FormatValidator.new(:attributes => [:email], :with => EmailFormat), ActiveRecord::Validations::UniquenessValidator.new(:attributes => [:email])]
    @user.validations = validations
    @user.valid?.must_equal false
    @user.errors.count.must_equal 2
  end
end
