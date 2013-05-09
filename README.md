# ContextValidations #

[![Build Status](https://secure.travis-ci.org/dockyard/context_validations.png?branch=master)](http://travis-ci.org/dockyard/context_validations)
[![Dependency Status](https://gemnasium.com/dockyard/context_validations.png?travis)](https://gemnasium.com/dockyard/context_validations)
[![Code Climate](https://codeclimate.com/github/dockyard/context_validations.png)](https://codeclimate.com/github/dockyard/context_validations)

Context based validations for model instances.

## Looking for help? ##

If it is a bug [please open an issue on GitHub](https://github.com/dockyard/context_validations/issues).

## Installation ##

In your `Gemfile`

```ruby
gem 'context_validations'
```

You can either mixin the moduels on a case-by-case basis or make the
changes global:

### Case-by-case ###

```ruby
# model
class User < ActiveModel::Base
  include ContextValidations::Model
end

# controller
class UsersController < ApplicationController
  include ContextValidations::Controller
end
```

### Global ###
Create an initializer: `config/initializers/context_validations.rb`

```ruby
class ActiveRecord::Base
  include ContextValidations::Model
end

class ApplicationController
  include ContextValidations::Controller
end
```

## Usage ##

```ruby
class UserController < ApplicationController
  include ContextValidations::Controller

  def create
    @user = User.new(user_params)
    @user.validations = validations(:create)

    if @user.save
      # happy path
    else
      # sad path
    end
  end

  private

  def create_validations
    validates :password, :presence => true
  end

  def base_validations
    validates :first_name, :last_name, :presence => true
    validates :password, :confirmation => true
    validates :email, :uniqueness => true, :format => EmailFormat
  end
end

class User < ActiveRecord::Base
  include ContextValidations::Model
end
```

### Controllers ###
In the above example we just call `validations` and pass the context. We
set the result to `#validations=` on the model.

While this does introduce some complexity into our controllers it frees
us from the mental gymnastics of conditional validators and state flags.

The corresponding `#{context}_validations` method, in this case
`create_validations` defines the validations that will be used. Call the
`#validates` method just like you would in model validations, the API is
identical.

A `#base_validations` method is always called prior to
`#{context}_validations` that will allow you to group together common
validations. The result of these methods appends onto a `@validations`
array.

If you are using `Ruby 2.0+` you can use implicit contexts:

```ruby
def create
  @user = User.new(user_params)
  # Notice we are only calling the #validations method and not passing
  # context. In this example the context is derived from the calling
  # method `create`
  @user.validations = validations  
end

private

def create_validations
  ...
end
```

### Models ###
When the `ContextValidations::Model` module is mixed into the model all
of the validation callbacks are removed from that model.

Because we are setting the validations on the instance you should not
use `ActiveRecord::Base.create` as we do not want to allow the
validations to be set via mass-assignment. This does introduce an extra
step in some places but it shouldn't be that big of a deal.

### Setting 
## Authors ##

* [Brian Cardarella](http://twitter.com/bcardarella)

[We are very thankful for the many contributors](https://github.com/dockyard/context_validations/graphs/contributors)

## Versioning ##

This gem follows [Semantic Versioning](http://semver.org)

## Want to help? ##

Please do! We are always looking to improve this gem. Please see our
[Contribution Guidelines](https://github.com/dockyard/context_validations/blob/master/CONTRIBUTING.md)
on how to properly submit issues and pull requests.

## Legal ##

[DockYard](http://dockyard.com), LLC &copy; 2013

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)
