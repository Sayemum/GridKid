# Name: Sayemum Hassan
# Date: 3/30/2024
# Description: The Block Module that contains a sequence of statements

require_relative('UnaryOperator.rb')

class Block
    include UnaryOperator

    def traverse(visitor, payload)
        visitor.visit_block(self, payload)
    end
end