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
    validations = [
      {class: ActiveModel::Validations::PresenceValidator, options: { :attributes => [:first_name] }},
      {class: ActiveModel::Validations::FormatValidator, options: { :attributes => [:email], :with => EmailFormat }},
      {class: ActiveRecord::Validations::UniquenessValidator, options: { :attributes => [:email] }}
    ]
    @user.validations = validations
    @user.valid?.must_equal false
    @user.errors.count.must_equal 2
  end

  it 'respect conditional validations set onto the instance' do
    validations = [
      {class: ActiveModel::Validations::PresenceValidator, options: { :attributes => [:first_name], :if => :can_validate? }},
      {class: ActiveModel::Validations::PresenceValidator, options: { :attributes => [:first_name], :if => Proc.new { |model| model.can_validate? }}},
      {class: ActiveModel::Validations::PresenceValidator, options: { :attributes => [:first_name], :unless => :cannot_validate? }},
      {class: ActiveModel::Validations::PresenceValidator, options: { :attributes => [:first_name], :unless => Proc.new { |model| model.cannot_validate? }}}
    ]
    def @user.can_validate?
      false
    end
    def @user.cannot_validate?
      true
    end
    @user.validations = validations
    @user.valid?.must_equal true
  end
end
