# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The Casting Module that contains all 2 casting types

require_relative('UnaryOperator.rb')

module Casting
    class FloatToInt
        include UnaryOperator

        def traverse(visitor, payload)
            visitor.visit_float_to_int(self, payload)
        end
    end

    class IntToFloat
        include UnaryOperator

        def traverse(visitor, payload)
            visitor.visit_int_to_float(self, payload)
        end
    end
end

