# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The Cell Value Module that contains all 2 cell value types

module CellValue
    class CellLValue
        attr_reader :row, :column, :start_index, :end_index

        def initialize(row, column, start_index=-1, end_index=-1)
            @row = row
            @column = column
            @start_index = start_index
            @end_index = end_index
        end

        def traverse(visitor, payload)
            visitor.visit_cell_l(self, payload)
        end
    end

    class CellRValue
        attr_reader :row, :column, :start_index, :end_index

        def initialize(row, column, start_index=-1, end_index=-1)
            @row = row
            @column = column
            @start_index = start_index
            @end_index = end_index
        end

        def traverse(visitor, payload)
            visitor.visit_cell_r(self, payload)
        end
    end
end

