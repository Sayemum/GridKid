# Name: Sayemum Hassan
# Date: 3/30/2024
# Description: The For-Each Loop Module that contains the iterator name, starting cell address, ending cell address, and the block

class ForEachLoop
    attr_reader :iterator_name, :start_cell, :end_cell, :block, :start_index, :end_index

    def initialize(iterator_name, start_cell, end_cell, block, start_index=-1, end_index=-1)
        @iterator_name = iterator_name
        @start_cell = start_cell
        @end_cell = end_cell
        @block = block
        @start_index = start_index
        @end_index = end_index
    end

    def traverse(visitor, payload)
        visitor.visit_for_each_loop(self, payload)
    end
end