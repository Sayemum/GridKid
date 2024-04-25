# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The Bitwise Module that contains all 6 bitwise types

require_relative('BinaryOperator.rb')
require_relative('UnaryOperator.rb')

module Bitwise
    class AndBitwise
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_and_bitwise(self, payload)
        end
    end

    class OrBitwise
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_or_bitwise(self, payload)
        end
    end

    class XorBitwise
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_xor_bitwise(self, payload)
        end
    end

    class NotBitwise
        include UnaryOperator

        def traverse(visitor, payload)
            visitor.visit_not_bitwise(self, payload)
        end
    end

    class LeftShift
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_left_shift_bitwise(self, payload)
        end
    end

    class RightShift
        include BinaryOperator

        def traverse(visitor, payload)
            visitor.visit_right_shift_bitwise(self, payload)
        end
    end
end

