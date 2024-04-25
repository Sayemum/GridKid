# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The Arithmetic Module that contains all 7 arithmetic types

require_relative('BinaryOperator.rb')
require_relative('UnaryOperator.rb')

module Arithmetic
    class Add
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_add(self, payload)
        end
    end

    class Subtract
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_subtract(self, payload)
        end
    end

    class Multiply
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_multiply(self, payload)
        end
    end

    class Divide
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_divide(self, payload)
        end
    end

    class Modulo
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_modulo(self, payload)
        end
    end

    class Exponent
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_exponent(self, payload)
        end
    end

    class Negate
        include UnaryOperator

        def traverse(visitor, payload)
            visitor.visit_negate(self, payload)
        end
    end
end

