# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The Primitive Module that contains all 5 primitive types

require_relative('UnaryOperator.rb')

class Primitive
    include UnaryOperator

    def traverse(visitor, payload)
        visitor.visit_primitive(self, payload)
    end
end