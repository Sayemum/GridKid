# Name: Sayemum Hassan
# Date: 3/22/2024
# Description: The Display Panel that shows the primitive value in the display window which is read-only.

require 'curses'

class DisplayPanel
    attr_accessor :window, :interface

    def initialize(interface)
        @interface = interface
        @window = Curses::Window.new(Curses.lines / 2, Curses.cols / @interface.grid_size, 0, @interface.grid_size * 8)
    end

    def draw_display_panel
        grid_pos = @interface.grid_pos

        @window.clear

        @window.setpos(1, 1)
        @window.addstr("Display Panel")

        # Draw the primitive value in the display panel
        str = "-"
        grid_cell = @interface.grid.grid[grid_pos[0]][grid_pos[1]]
        if !grid_cell.nil?
            str = grid_cell.runtime.get_primitive(Primitive.new([grid_pos[0], grid_pos[1]])).value.to_s
        end
        @window.setpos(2,1)
        @window.addstr(str)

        @window.box("|", "-")  # Draw the grid box
        @window.refresh
    end
end