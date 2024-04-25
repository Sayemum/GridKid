# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The Relational Module that contains all 6 relational types

require_relative('BinaryOperator.rb')

module Relational
    class Equals
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_equals(self, payload)
        end
    end

    class NotEquals
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_not_equals(self, payload)
        end
    end

    class LessThan
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_less_than(self, payload)
        end
    end
    
    class LessThanOrEqual
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_less_than_or_equal(self, payload)
        end
    end

    class GreaterThan
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_greater_than(self, payload)
        end
    end

    class GreaterThanOrEqual
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_greater_than_or_equal(self, payload)
        end
    end
end

