module ContextValidations
  module ValidationsFor
    module MiniTest
      def validations_for(action)
        determine_constant_from_test_name.new.validations(action)
      end

      def determine_constant_from_test_name
        names = self.class.name.split('::')

        while names.size > 0 do
          names.last.sub!(/Test$/, '')
          begin
            constant = names.join('::').constantize
            break(constant) if constant
          rescue NameError
            # Constant wasn't found, move on
          ensure
            names.pop
          end
        end
      end
    end
  end
end

MiniTest::Unit::TestCase.send(:include, ContextValidations::ValidationsFor::MiniTest)
