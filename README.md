# StrongValidations #

[![Build Status](https://secure.travis-ci.org/dockyard/strong_validations.png?branch=master)](http://travis-ci.org/dockyard/strong_validations)
[![Dependency Status](https://gemnasium.com/dockyard/strong_validations.png?travis)](https://gemnasium.com/dockyard/strong_validations)
[![Code Climate](https://codeclimate.com/github/dockyard/strong_validations.png)](https://codeclimate.com/github/dockyard/strong_validations)

Rails exceptions automatically opened as issues on GitHub

## Looking for help? ##

If it is a bug [please open an issue on GitHub](https://github.com/dockyard/strong_validations/issues).

## About ##

Context based validations for model instances.

## Example ##

```ruby
class UserController < ApplicationController
  include StrongValidations::Controller

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
    validates(:first_name, :last_name, :presence => true),
    validates(:email, :uniqueness => true, :format => EmailFormat)
  end
end

class User < ActiveRecord::Base
  include StrongValidations::Model
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

### Models ###
When the `StrongValidations::Model` module is mixed into the module all
of the validation callbacks are removed from that model.

Because we are setting the validations on the instance you should not
use `ActiveRecord::Base.create` as we do not want to allow the
validations to be set via mass-assignment. This does introduce an extra
step in some places but it shouldn't be that big of a deal.

## Authors ##

* [Brian Cardarella](http://twitter.com/bcardarella)

[We are very thankful for the many contributors](https://github.com/dockyard/strong_validations/graphs/contributors)

## Versioning ##

This gem follows [Semantic Versioning](http://semver.org)

## Want to help? ##

Please do! We are always looking to improve this gem. Please see our
[Contribution Guidelines](https://github.com/dockyard/strong_validations/blob/master/CONTRIBUTING.md)
on how to properly submit issues and pull requests.

## Legal ##

[DockYard](http://dockyard.com), LLC &copy; 2013

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)
