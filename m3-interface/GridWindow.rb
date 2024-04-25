# Name: Sayemum Hassan
# Date: 3/22/2024
# Description: The Grid Window that shows the 2D Grid in the Curses Window

require 'curses'

class GridWindow
    attr_accessor :grid_size, :window, :interface

    def initialize(grid_size, interface)
        @grid_size = grid_size
        @interface = interface
        @window = Curses::Window.new(Curses.lines, @grid_size * 7, 0, 0)
    end

    def draw_grid
        grid_pos = @interface.grid_pos

        @window.clear
        draw_labels

        (0...@grid_size).each do |row|
            (0...@grid_size).each do |col|
                cell_pos_x = col * 6 + 4  # Adjust cell positioning
                cell_pos_y = row * 3 + 2  # Adjust for row labels

                # Draw cell content (up to first 3 characters)
                @window.setpos(cell_pos_y, cell_pos_x)

                str = "-"
                grid_cell = @interface.grid.grid[col][row]
                if !grid_cell.nil?
                    str = grid_cell.runtime.get_primitive(Primitive.new([col, row])).value.to_s
                    if str.length > 3
                        str = str[0,3] + ".."
                    end
                end
                if grid_pos == [col, row]
                    @window.attron(Curses::A_REVERSE)
                    @window.addstr(str)
                else
                    @window.attroff(Curses::A_REVERSE)
                    @window.addstr(str)
                end
                
            end
        end

        @window.box("|", "-")  # Draw the grid box
        @window.refresh
    end

    # Helper method to draw column and row labels
    def draw_labels
        # Draw column labels at the top
        @window.setpos(1, 3)  # Start drawing labels from this position
        (0...@grid_size).each { |col| @window.addstr(" #{col}    ") }
    
        # Draw row labels at the left
        (0...@grid_size).each do |row|
            @window.setpos(row * 3 + 2, 1)  # Adjust positioning for row labels
            @window.addstr("#{row}")
        end
    end

    def navigate_grid(direction)
        case direction
        when 'w'
            # Move cursor up
            @interface.grid_pos[1] = [@interface.grid_pos[1] - 1, 0].max
        when 's'
            @interface.grid_pos[1] = [@interface.grid_pos[1] + 1, @grid_size - 1].min
        when 'a'
            @interface.grid_pos[0] = [@interface.grid_pos[0] - 1, 0].max
        when 'd'
            @interface.grid_pos[0] = [@interface.grid_pos[0] + 1, @grid_size - 1].min
        end
        
        draw_grid
        @interface.display_panel.draw_display_panel
        @interface.formula_editor.draw_formula_editor
    end

end