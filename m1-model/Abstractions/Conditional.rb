# Name: Sayemum Hassan
# Date: 3/30/2024
# Description: The Conditional Module that contains the condition and two blocks

class Conditional
    attr_reader :condition, :then_block, :else_block, :start_index, :end_index

    def initialize(condition, then_block, else_block, start_index=-1, end_index=-1)
        @condition = condition
        @then_block = then_block
        @else_block = else_block
        @start_index = start_index
        @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_conditional(self, payload)
    end
end