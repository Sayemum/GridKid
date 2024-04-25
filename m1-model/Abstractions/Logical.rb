# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The Logical Module that contains all 3 logical types

require_relative('BinaryOperator.rb')
require_relative('UnaryOperator.rb')

module Logical
    class AndLogical
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_and_logical(self, payload)
        end
    end

    class OrLogical
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_or_logical(self, payload)
        end
    end

    class NotLogical
        include UnaryOperator

        def traverse(visitor, payload)
            visitor.visit_not_logical(self, payload)
        end
    end
end

