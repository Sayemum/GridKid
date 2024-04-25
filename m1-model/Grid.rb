# Name: Sayemum Hassan
# Date: 2/11/2024
# Description: The Grid that maintains all the cells

require_relative('../m1-model/Abstractions/CellValue.rb')

class Cell
    attr_accessor :primitive
    attr_reader :source_code, :ast, :runtime

    def initialize(source_code, ast, primitive, runtime)
        @source_code = source_code
        @ast = ast
        @primitive = primitive
        @runtime = runtime
    end
end

class Grid
    attr_reader :grid

    def initialize
        @grid = Array.new(7) { Array.new(7, nil) }
        #@runtime = nil
        #@called_set_runtime = false
    end

=begin
    def set_runtime(runtime)
        if @called_set_runtime == false
            @called_set_runtime = true
            @runtime = runtime
        else
            raise "set_runtime has already been called once on the grid"
        end
    end
=end

    # M3: recalculate_grid
    def recalculate_grid
        evaluator = Evaluator.new
        @grid.each_with_index do |row, row_idx|
            row.each_with_index do |cell, col_idx|
            next unless cell.is_a?(Cell) # Skip if the cell is not a Cell object

            # Recalculate the primitive value using the cell's AST
            new_primitive = cell.ast.traverse(evaluator, cell.runtime)
            cell.primitive = new_primitive
            end
        end
    end

    # address takes a CellAddressPrimitive value
    # source_code is the serialized representation of the ast
    def set_cell(address, source_code, ast)
        evaluator = Evaluator.new
        runtime = Runtime.new(self)
        primitive = ast.traverse(evaluator, runtime)

        @grid[address.value[0]][address.value[1]] = Cell.new(source_code, ast, primitive, runtime)
        recalculate_grid
    end

    def get_cell(address)
        @grid[address.value[0]][address.value[1]]
    end

    def get_primitive(address)
        cell = @grid[address.value[0]][address.value[1]]

        if !cell.is_a?(Cell) then
            return
        end

        cell.primitive
    end
end