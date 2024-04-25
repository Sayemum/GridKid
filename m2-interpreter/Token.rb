# Name: Sayemum Hassan
# Date: 2/23/2024
# Description: The Token Class

class Token
    attr_reader :type, :text, :start_index, :end_index

    def initialize(type, text, start_index, end_index)
        @type = type
        @text = text
        @start_index = start_index
        @end_index = end_index
    end
end