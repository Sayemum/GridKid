# Name: Sayemum Hassan
# Date: 2/11/2024
# Description: The Runtime that manages the execution of the program's runtime environment.

class Runtime
    attr_reader :grid, :vars

    def initialize(grid)
        raise "Runtime initialized without a Grid instance" unless grid.is_a?(Grid)
        @grid = grid
        @vars = {}
    end

    def define_var(name, value)
        @vars[name] = value
    end

    def get_var(name)
        raise "Variable #{name} not defined" unless @vars.key?(name)
        var = @vars[name]
        var
    end

    def get_primitive(address)
        raise "Attempting to access grid as an Array, not Grid" unless @grid.is_a?(Grid)
        @grid.get_primitive(address)
    end

    def set_cell(address, source_code, ast)
        @grid.set_cell(address, source_code, ast)
    end
end