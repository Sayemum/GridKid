# Name: Sayemum Hassan
# Date: 3/22/2024
# Description: The Formular Editor shows a cell's unevaluated source.

require_relative('../m2-interpreter/Token.rb')
require_relative('../m2-interpreter/Lexer.rb')
require_relative('../m2-interpreter/Parser.rb')
require_relative('../m1-model/Evaluator.rb')
require_relative('../m1-model/Serializer.rb')
require_relative('../m1-model/Runtime.rb')
require_relative('../m1-model/Grid.rb')
require_relative('../m1-model/Abstractions/Primitive.rb')

require 'curses'

class FormulaEditor
    #source_code is a list of chars, it shows in the panel as a string
    attr_accessor :window, :formula_cursor_pos, :interface, :source_code

    def initialize(interface)
        @interface = interface
        @formula_cursor_pos = [2, 1]
        @source_code = []
        @window = Curses::Window.new(Curses.lines / 2, Curses.cols / @interface.grid_size, Curses.lines / 2, @interface.grid_size * 8)
    end

    def draw_formula_editor
        @window.clear

        @window.setpos(1, 1)
        @window.addstr("Formula Editor")

        # Show currently selected cell's formula
        @source_code = []
        current_grid = @interface.grid.grid[@interface.grid_pos[0]][@interface.grid_pos[1]]
        if current_grid.is_a?(Cell)
            if current_grid.ast.is_a?(Primitive)
                @source_code = current_grid.source_code.chars
            else
                @source_code = ['='] + current_grid.source_code.chars
            end
        end
        @window.setpos(2,1)
        @window.addstr(@source_code.join(""))

        @window.box("|", "-")  # Draw the grid box
        @window.refresh
    end

    # helper to determine if the source code is a primitive type
    def check_primitive_type
        str = @source_code.join("")
        
        return :int, str.to_i if str.match?(/\A[+-]?\d+\z/)
        return :float, str.to_f if str.match?(/\A[+-]?\d+\.\d+\z/) || str.match?(/\A[+-]?\d+([eE][+-]?\d+)\z/)
        return :true, true if str.downcase == "true"
        return :false, false if str.downcase == "false"
        
        [:string, str] # Implicitly returns an array containing :string and str
    end
    
    def navigate_formula_editor(key)
        case key
        when 127, 8
            # Delete the last character in the formula editor
            @source_code.pop()
            @formula_cursor_pos[1] = [@formula_cursor_pos[1] - 1, 0].max
            @window.clear
            @window.addstr(@source_code.join(""))
        when 10 # TODO: Drop a new line
            @source_code.append("\n")
        when '`' # Switch to view mode
            # begin
                @interface.mode = "view"
                error_message = nil

                if @source_code[0] == '='
                    # Lex and parse the source code
                    lexer = Lexer.new(@source_code[1..].join(""))
                    tokens = lexer.lex

                    parser = Parser.new(tokens)
                    ast = parser.parse

                    cell_runtime = Runtime.new(@interface.grid)

                    primitive = ast.traverse(Evaluator.new, cell_runtime)
                    text = ast.traverse(Serializer.new, cell_runtime)

                    @interface.grid.set_cell(Primitive.new([@interface.grid_pos[0], @interface.grid_pos[1]]), text, ast)
                else
                    # Treat as a primitive (int, float, bool) OR plain string
                    cell_address = Primitive.new([@interface.grid_pos[0], @interface.grid_pos[1]])

                    primitive_type, primitive = check_primitive_type
                    if primitive_type == :int || primitive_type == :float || primitive_type == :true || primitive_type == :false
                        @interface.grid.set_cell(cell_address, @source_code.join(""), Primitive.new(primitive))
                    else # is a string
                        @interface.grid.set_cell(cell_address, @source_code.join(""), Primitive.new(@source_code.join("")))
                    end
                end


            # Handling Error Exceptions
            # rescue => e
            #     error_message = "Unexpected error: #{e.message}"
            # ensure
            #     # Ensure block to handle UI refresh or error message display
            #     unless error_message.nil?
            #         # If there's an error message, display it (consider adding a method to display errors)
            #         @window.addstr(" " + error_message)
            #         @window.getch
            #     else
            #         # Proceed with UI refresh if no errors occurred
            #         @interface.grid_window.draw_grid()
            #         @interface.display_panel.draw_display_panel()
            #         draw_formula_editor()
            #     end
            # end

            
        when 27 # Escape key
            @interface.close_application
        else
            # Insert the character into the formula editor
            @source_code.append(key)
            @formula_cursor_pos[1] = [@formula_cursor_pos[1] + 1, @source_code.length - 1].min
            @window.clear
            @window.addstr(@source_code.join(""))
        end
        @window.refresh
    end

    def edit_formula_loop
        @window.clear

        while @interface.mode == "edit"
            @source_code.join("").lines.each_with_index do |line, i|
                @window.setpos(i, 0)
                @window.addstr(line)
            end
            
            key = @window.getch
            navigate_formula_editor(key)
        end
    end
end