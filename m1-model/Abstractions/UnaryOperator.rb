# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The UnaryOperator Module that contains the constructor and methods for all types with 1 value

module UnaryOperator
    attr_reader :value, :start_index, :end_index

    def initialize(value, start_index=-1, end_index=-1)
        @value = value
        @start_index = start_index
        @end_index = end_index
    end
end