# Name: Sayemum Hassan
# Date: 3/3/2024
# Description: The BinaryOperator Module that contains the constructor and methods for all binary operators with a left and right

module BinaryOperator
    attr_reader :left, :right, :start_index, :end_index

    def initialize(left, right, start_index=-1, end_index=-1)
        @left = left
        @right = right
        @start_index = start_index
        @end_index = end_index
    end
end