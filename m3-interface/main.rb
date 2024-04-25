# Name: Sayemum Hassan
# Date: 3/22/2024
# Description: The main script for milestone 3

require 'curses'

require_relative('../m2-interpreter/Token.rb')
require_relative('../m2-interpreter/Lexer.rb')
require_relative('../m2-interpreter/Parser.rb')
require_relative('../m1-model/Evaluator.rb')
require_relative('../m1-model/Serializer.rb')
require_relative('../m1-model/Runtime.rb')
require_relative('../m1-model/Grid.rb')
require_relative('../m1-model/Abstractions/Primitive.rb')

require_relative('GridWindow.rb')
require_relative('DisplayPanel.rb')
require_relative('FormulaEditor.rb')

# Configurations
GRID_SIZE = 7


class Interface
    attr_accessor :grid_size, :grid_pos, :grid, :running, :mode, :grid_window, :display_panel, :formula_editor

    def initialize(grid)
        @grid_size = GRID_SIZE
        @grid_pos = [0, 0]
        @grid = grid
        @running = true
        @mode = "view"

        @grid_window = GridWindow.new(@grid_size, self)
        @display_panel = DisplayPanel.new(self)
        @formula_editor = FormulaEditor.new(self)

        setup_curses
    end

    def setup_curses
        Curses.init_screen
        Curses.noecho
        Curses.curs_set(0)
        Curses.start_color
    end

    # This is the start of the interface which will draw the windows
    # and place the cursor at the top left of the grid. This will also listen for key presses
    # and move the cursor accordingly.
    def main_loop
        while @running
            @grid_window.draw_grid
            @display_panel.draw_display_panel
            @formula_editor.draw_formula_editor

            handle_user_input
        end
    end

    # The main function that listens for key presses and moves cursor accordingly.
    # There will be special keys for switching from view/edit modes like 'v' and 'e'
    # There will be a key for exiting the program like 'q' or 'esc'
    def handle_user_input
        key = @grid_window.window.getch
        case key
        when 'w', 'a', 's', 'd'
            if @mode == "view"
                @grid_window.navigate_grid(key)
            end
        when 9 # Switch to edit mode
            @mode = "edit" if @mode == "view"
            @formula_editor.edit_formula_loop
        when 27 # Escape key
            close_application
        end
    end

    def close_application
        @running = false
        @grid_window.window.close
        Curses.close_screen
    end
end

#Grid Runtime
grid = Grid.new

grid.set_cell(Primitive.new([0, 0]), "1 + 1", Arithmetic::Add.new(Primitive.new(1), Primitive.new(1)))
grid.set_cell(Primitive.new([1, 0]), "1 + 2", Arithmetic::Add.new(Primitive.new(1), Primitive.new(2)))

interface = Interface.new(grid)
interface.main_loop