# Name: Sayemum Hassan
# Date: 3/30/2024
# Description: The Assignment Module that contains a variable be treated as an L-Value

require_relative('BinaryOperator.rb')

class Assignment
    include BinaryOperator

    def traverse(visitor, payload)
        visitor.visit_assignment(self, payload)
    end
end