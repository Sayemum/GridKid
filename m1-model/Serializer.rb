class Serializer
    ### MILESTONE 4
    def visit_block(node, runtime)
        # # Loop through all entries in @value by doing traverse with the passed runtime
        statements = node.value
        
        result = ""
        statements.each do |statement|
            node_val = statement.traverse(self, runtime)
            result += "#{node_val}\n"
        end

        result
    end

    def visit_assignment(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} = #{right_val}"
    end

    def visit_var_reference(node, runtime)
        node.value
    end

    def visit_conditional(node, runtime)
        condition = node.condition.traverse(self, runtime)
        then_block = node.then_block.traverse(self, runtime)
        else_block = node.else_block.traverse(self, runtime)
        "if (#{condition}) {\n  #{then_block}} else {\n  #{else_block}}\n"
    end

    def visit_for_each_loop(node, runtime)
        iterator_name = node.iterator_name.traverse(self, runtime)
        start_cell = node.start_cell.traverse(self, runtime)
        end_cell = node.end_cell.traverse(self, runtime)
        block = node.block.traverse(self, runtime)
        "for #{iterator_name} in #{start_cell}..#{end_cell} {\n  #{block}\n}"
    end


    ### PRIMITIVE:
    def visit_primitive(node, nothing)
        node.value.to_s
    end

    
    ### ARITHMETIC:
    def visit_add(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} + #{right_val}"
    end

    def visit_subtract(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} - #{right_val}"
    end

    def visit_multiply(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} * #{right_val}"
    end

    def visit_divide(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} / #{right_val}"
    end

    def visit_modulo(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} % #{right_val}"
    end

    def visit_exponent(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} ** #{right_val}"
    end

    def visit_negate(node, runtime)
        node_val = node.value.traverse(self, runtime)
        negated = -node_val
        "#{negated}"
    end



    ### LOGICAL:
    def visit_and_logical(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} && #{right_val}"
    end

    def visit_or_logical(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} || #{right_val}"
    end

    def visit_not_logical(node, runtime)
        node_val = node.value.traverse(self, runtime)
        "!#{node_val}"
    end



    ### CELL L-VALUE:
    def visit_cell_l(node, runtime)
        row_val = node.row.traverse(self, runtime)
        column_val = node.column.traverse(self, runtime)
        "[#{row_val}, #{column_val}]"
    end



    ### CELL R-VALUE:
    def visit_cell_r(node, runtime)
        row_val = node.row.traverse(self, runtime)
        column_val = node.column.traverse(self, runtime)
        "#[#{row_val}, #{column_val}]"
    end



    ### BITWISE:
    def visit_and_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} & #{right_val}"
    end

    def visit_or_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} | #{right_val}"
    end

    def visit_xor_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} ^ #{right_val}"
    end

    def visit_not_bitwise(node, runtime)
        node_val = node.value.traverse(self, runtime)
        "~#{node_val}"
    end

    def visit_left_shift_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} << #{right_val}"
    end

    def visit_right_shift_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} >> #{right_val}"
    end



    ### RELATIONAL:
    def visit_equals(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} == #{right_val}"
    end

    def visit_not_equals(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} != #{right_val}"
    end

    def visit_less_than(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} < #{right_val}"
    end

    def visit_less_than_or_equal(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} <= #{right_val}"
    end

    def visit_greater_than(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} > #{right_val}"
    end

    def visit_greater_than_or_equal(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        "#{left_val} >= #{right_val}"
    end



    ### CASTING:
    def visit_float_to_int(node, runtime)
        node_val = node.value.traverse(self, runtime)
        "int(#{node_val})"
    end

    def visit_int_to_float(node, runtime)
        node_val = node.value.traverse(self, runtime)
        "float(#{node_val})"
    end



    ### STATISTICS:
    def visit_max(node, runtime)
        top_left_val = node.top_left.traverse(self, runtime)
        top_right_val = node.bottom_right.traverse(self, runtime)
        "max(#{top_left_val}, #{top_right_val})"
    end

    def visit_min(node, runtime)
        top_left_val = node.top_left.traverse(self, runtime)
        top_right_val = node.bottom_right.traverse(self, runtime)
        "min(#{top_left_val}, #{top_right_val})"
    end

    def visit_mean(node, runtime)
        top_left_val = node.top_left.traverse(self, runtime)
        top_right_val = node.bottom_right.traverse(self, runtime)
        "mean(#{top_left_val}, #{top_right_val})"
    end

    def visit_sum(node, runtime)
        top_left_val = node.top_left.traverse(self, runtime)
        top_right_val = node.bottom_right.traverse(self, runtime)
        "sum(#{top_left_val}, #{top_right_val})"
    end
end