class Evaluator
    ### MILESTONE 4
    def visit_block(node, runtime)
        statements = node.value
        final_val = nil

        statements.each do |statement|
            node_val = statement.traverse(self, runtime)
            final_val = node_val
        end

        final_val
    end

    def visit_assignment(node, runtime)
        # Evaluate right side
        left_val = node.left
        right_val = node.right.traverse(self, runtime)

        raise TypeError, 'Left operand must be a string' unless left_val.value.is_a?(String)

        # Store binding in a key-value store in Runtime
        runtime.define_var(left_val.value, right_val)
    end

    def visit_var_reference(node, runtime)
        # Look up and return primitive value stored in Runtime using Left Value
        raise TypeError, 'Node operand must be a string' unless node.value.is_a?(String)
        value = runtime.get_var(node.value)
        value
    end

    def visit_conditional(node, runtime)
        # Evaluate condition (true or false)
        cond_val = node.condition.traverse(self, runtime)

        raise TypeError, 'Conditional operand must be a boolean' unless cond_val.value.is_a?(TrueClass) || cond_val.value.is_a?(FalseClass)

        return_val = nil
        if cond_val.value.is_a?(TrueClass) # Run then-block if true
            return_val = node.then_block.traverse(self, runtime)
        else # Run else-block if false
            return_val = node.else_block.traverse(self, runtime)
        end

        # Returned value is value returned by the associated block
        return_val
    end

    def visit_for_each_loop(node, runtime)
        # Iterate through 2D grid of cells
        top_left = node.start_cell
        bottom_right = node.end_cell
        iterator_name = node.iterator_name
        final_val = nil

        raise TypeError, 'Top-left operand must be an array' unless top_left.value.is_a?(Array)
        raise TypeError, 'Bottom-right operand must be an array' unless bottom_right.value.is_a?(Array)
        raise TypeError, 'iterator name operand must be a string' unless iterator_name.value.is_a?(String)

        #TODO: adding to a variable with non integer/float values cause an error
        (top_left.value[0]..bottom_right.value[0]).each do |row|
            (top_left.value[1]..bottom_right.value[1]).each do |col|
                # Create a variable in each cell's runtime with given name and set value equal to the cell's value
                cell_value = runtime.get_primitive(Primitive.new([row, col]))
                if cell_value.is_a?(Primitive) then
                    # Assign each cell's value to a local variable with given name
                    runtime.define_var(iterator_name.value, cell_value)

                    # Evaluate the block for each cell.
                    final_val = node.block.traverse(self, runtime)
                end
                
            end
        end

        # The value returned by the block on the final iteration is value returned by larger loop.
        final_val
    end


    ### PRIMITIVE:
    def visit_primitive(node, payload)
        node
    end


    ### ARITHMETIC:
    def visit_add(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)

        raise TypeError, 'Left operand must be an integer or float' unless left_val.value.is_a?(Integer) || left_val.value.is_a?(Float)
        raise TypeError, 'Right operand must be an integer or float' unless right_val.value.is_a?(Integer) || right_val.value.is_a?(Float)
        
        Primitive.new(left_val.value + right_val.value)
    end

    def visit_subtract(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)

        raise TypeError, 'Left operand must be an integer or float' unless left_val.value.is_a?(Integer) || left_val.value.is_a?(Float)
        raise TypeError, 'Right operand must be an integer or float' unless right_val.value.is_a?(Integer) || right_val.value.is_a?(Float)
        
        Primitive.new(left_val.value - right_val.value)
    end

    def visit_multiply(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)

        raise TypeError, 'Left operand must be an integer or float' unless left_val.value.is_a?(Integer) || left_val.value.is_a?(Float)
        raise TypeError, 'Right operand must be an integer or float' unless right_val.value.is_a?(Integer) || right_val.value.is_a?(Float)
        
        Primitive.new(left_val.value * right_val.value)
    end

    def visit_divide(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)

        raise TypeError, 'Left operand must be an integer or float' unless left_val.value.is_a?(Integer) || left_val.value.is_a?(Float)
        raise TypeError, 'Right operand must be an integer or float' unless right_val.value.is_a?(Integer) || right_val.value.is_a?(Float)
        
        Primitive.new(left_val.value / right_val.value)
    end

    def visit_modulo(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)

        raise TypeError, 'Left operand must be an integer or float' unless left_val.value.is_a?(Integer) || left_val.value.is_a?(Float)
        raise TypeError, 'Right operand must be an integer or float' unless right_val.value.is_a?(Integer) || right_val.value.is_a?(Float)
        
        Primitive.new(left_val.value % right_val.value)
    end

    def visit_exponent(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)

        raise TypeError, 'Left operand must be an integer or float' unless left_val.value.is_a?(Integer) || left_val.value.is_a?(Float)
        raise TypeError, 'Right operand must be an integer or float' unless right_val.value.is_a?(Integer) || right_val.value.is_a?(Float)
        
        Primitive.new(left_val.value ** right_val.value)
    end

    def visit_negate(node, runtime)
        node_val = node.value.traverse(self, runtime)

        raise TypeError, 'Node operand must be an integer or float' unless node_val.value.is_a?(Integer) || node_val.value.is_a?(Float)

        Primitive.new(node_val.value * -1)
    end



    ### LOGICAL:
    def visit_and_logical(node, runtime)
        left_val = node.left.traverse(self, runtime)
        
        raise TypeError, 'Left operand must be a boolean' unless left_val.value.is_a?(TrueClass) || left_val.value.is_a?(FalseClass)

        # Short circuit left before evaluating right
        if left_val.value == false
            Primitive.new(false)
        end

        right_val = node.right.traverse(self, runtime)
        raise TypeError, 'Right operand must be a boolean' unless right_val.value.is_a?(TrueClass) || right_val.value.is_a?(FalseClass)

        Primitive.new(left_val.value && right_val.value)
    end

    def visit_or_logical(node, runtime)
        left_val = node.left.traverse(self, runtime)
        
        raise TypeError, 'Left operand must be a boolean' unless left_val.value.is_a?(TrueClass) || left_val.value.is_a?(FalseClass)

        # Short circuit left before evaluating right
        if left_val.value == true
            Primitive.new(true)
        end

        right_val = node.right.traverse(self, runtime)
        raise TypeError, 'Right operand must be a boolean' unless right_val.value.is_a?(TrueClass) || right_val.value.is_a?(FalseClass)

        Primitive.new(left_val.value || right_val.value)
    end

    def visit_not_logical(node, runtime)
        node_val = node.value.traverse(self, runtime)
        raise TypeError, 'Node operand must be a boolean' unless node_val.value.is_a?(TrueClass) || node_val.value.is_a?(FalseClass)

        Primitive.new(!node_val.value)
    end



    ### CELL L-VALUE:
    def visit_cell_l(node, runtime)
        row = node.row.traverse(self, runtime)
        column = node.column.traverse(self, runtime)
        
        raise TypeError, 'Row must be an integer' unless row.value.is_a?(Integer)
        raise TypeError, 'Column must be an integer' unless column.value.is_a?(Integer)

        Primitive.new([row.value, column.value])
    end



    ### CELL R-VALUE:
    def visit_cell_r(node, runtime)
        row = node.row.traverse(self, runtime)
        column = node.column.traverse(self, runtime)
    
        raise TypeError, 'Row must be an integer' unless row.value.is_a?(Integer)
        raise TypeError, 'Column must be an integer' unless column.value.is_a?(Integer)
    
        address = Primitive.new([row.value, column.value])
        runtime.get_primitive(address)
    end




    ### BITWISE:
    def visit_and_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, 'Left operand must be an integer' unless left_val.value.is_a?(Integer)
        raise TypeError, 'Right operand must be an integer' unless right_val.value.is_a?(Integer)

        Primitive.new(left_val.value & right_val.value)
    end

    def visit_or_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, 'Left operand must be an integer' unless left_val.value.is_a?(Integer)
        raise TypeError, 'Right operand must be an integer' unless right_val.value.is_a?(Integer)

        Primitive.new(left_val.value | right_val.value)
    end

    def visit_xor_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, 'Left operand must be an integer' unless left_val.value.is_a?(Integer)
        raise TypeError, 'Right operand must be an integer' unless right_val.value.is_a?(Integer)

        Primitive.new(left_val.value ^ right_val.value)
    end

    def visit_not_bitwise(node, runtime)
        node_val = node.value.traverse(self, runtime)
        
        raise TypeError, 'Node operand must be an integer' unless node_val.value.is_a?(Integer)

        Primitive.new(~node_val.value)
    end

    def visit_left_shift_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, 'Left operand must be an integer' unless left_val.value.is_a?(Integer)
        raise TypeError, 'Right operand must be an integer' unless right_val.value.is_a?(Integer)

        Primitive.new(left_val.value << right_val.value)
    end

    def visit_right_shift_bitwise(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, 'Left operand must be an integer' unless left_val.value.is_a?(Integer)
        raise TypeError, 'Right operand must be an integer' unless right_val.value.is_a?(Integer)

        Primitive.new(left_val.value >> right_val.value)
    end



    ### RELATIONAL:
    def visit_equals(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, "Left_val and Right_val must be of same class in order to compare" unless (left_val.value.class == right_val.value.class) ||
            ((left_val.value.class == TrueClass || left_val.value.class == FalseClass) && (right_val.value.class == TrueClass || right_val.value.class == FalseClass)) # Boolean comparison

        Primitive.new(left_val.value == right_val.value)
    end

    def visit_not_equals(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, "Left_val and Right_val must be of same class in order to compare" unless (left_val.value.class == right_val.value.class) ||
            ((left_val.value.class == TrueClass || left_val.value.class == FalseClass) && (right_val.value.class == TrueClass || right_val.value.class == FalseClass)) # Boolean comparison

        Primitive.new(left_val.value != right_val.value)
    end

    def visit_less_than(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, "Left_val and Right_val must be of same class in order to compare" unless (left_val.value.class == right_val.value.class) ||
            ((left_val.value.class == TrueClass || left_val.value.class == FalseClass) && (right_val.value.class == TrueClass || right_val.value.class == FalseClass)) # Boolean comparison

        Primitive.new(left_val.value < right_val.value)
    end

    def visit_less_than_or_equal(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, "Left_val and Right_val must be of same class in order to compare" unless (left_val.value.class == right_val.value.class) ||
            ((left_val.value.class == TrueClass || left_val.value.class == FalseClass) && (right_val.value.class == TrueClass || right_val.value.class == FalseClass)) # Boolean comparison

        Primitive.new(left_val.value <= right_val.value)
    end

    def visit_greater_than(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, "Left_val and Right_val must be of same class in order to compare" unless (left_val.value.class == right_val.value.class) ||
            ((left_val.value.class == TrueClass || left_val.value.class == FalseClass) && (right_val.value.class == TrueClass || right_val.value.class == FalseClass)) # Boolean comparison

        Primitive.new(left_val.value > right_val.value)
    end

    def visit_greater_than_or_equal(node, runtime)
        left_val = node.left.traverse(self, runtime)
        right_val = node.right.traverse(self, runtime)
        
        raise TypeError, "Left_val and Right_val must be of same class in order to compare" unless (left_val.value.class == right_val.value.class) ||
            ((left_val.value.class == TrueClass || left_val.value.class == FalseClass) && (right_val.value.class == TrueClass || right_val.value.class == FalseClass)) # Boolean comparison

        Primitive.new(left_val.value >= right_val.value)
    end



    ### CASTING:
    def visit_float_to_int(node, runtime)
        node_val = node.value.traverse(self, runtime)

        raise TypeError, 'Node operand must be a float' unless node_val.value.is_a?(Float)

        Primitive.new(node_val.value.to_i)
    end

    def visit_int_to_float(node, runtime)
        node_val = node.value.traverse(self, runtime)

        raise TypeError, 'Node operand must be an integer' unless node_val.value.is_a?(Integer)

        Primitive.new(node_val.value.to_f)
    end



    ### STATISTICS:
    def loop_cells(top_left, bottom_right, function_type, runtime, currentVal=0) # Helper Function
        result = currentVal
        total_cells = 0

        (top_left.value[0]..bottom_right.value[0]).each do |row|
            (top_left.value[1]..bottom_right.value[1]).each do |col|
                cell_value = runtime.get_primitive(Primitive.new([row, col]))
                if cell_value.is_a?(Primitive) then
                    if cell_value.value.is_a?(Integer) || cell_value.value.is_a?(Float)

                        case function_type
                        when "max"
                            if result.value < cell_value.value
                                result = cell_value
                            end
                        when "min"
                            if result.value > cell_value.value
                                result = cell_value
                            end
                        when "mean"
                            result += cell_value.value
                            total_cells += 1
                        when "sum"
                            result += cell_value.value
                        end
                    end
                end
            end
        end

        # special case for mean
        if function_type == "mean"
            result = result.to_f / total_cells
        end

        result
    end

    def visit_max(node, runtime)
        top_left = node.top_left.traverse(self, runtime)
        bottom_right = node.bottom_right.traverse(self, runtime)

        raise TypeError, 'top_left operand must be a cell address array' unless top_left.value.is_a?(Array)
        raise TypeError, 'bottom_right operand must be a cell address array' unless bottom_right.value.is_a?(Array)

        max_value = runtime.get_primitive(Primitive.new([top_left.value[0], top_left.value[1]]))

        loop_cells(top_left, bottom_right, "max", runtime, max_value)
    end

    def visit_min(node, runtime)
        top_left = node.top_left.traverse(self, runtime)
        bottom_right = node.bottom_right.traverse(self, runtime)

        raise TypeError, 'top_left operand must be a cell address array' unless top_left.value.is_a?(Array)
        raise TypeError, 'bottom_right operand must be a cell address array' unless bottom_right.value.is_a?(Array)

        min_value = runtime.get_primitive(Primitive.new([top_left.value[0], top_left.value[1]]))

        loop_cells(top_left, bottom_right, "min", runtime, min_value)
    end

    def visit_mean(node, runtime)
        top_left = node.top_left.traverse(self, runtime)
        bottom_right = node.bottom_right.traverse(self, runtime)

        raise TypeError, 'top_left operand must be a cell address array' unless top_left.value.is_a?(Array)
        raise TypeError, 'bottom_right operand must be a cell address array' unless bottom_right.value.is_a?(Array)

        mean_value = loop_cells(top_left, bottom_right, "mean", runtime)
        Primitive.new(mean_value)
    end

    def visit_sum(node, runtime)
        top_left = node.top_left.traverse(self, runtime)
        bottom_right = node.bottom_right.traverse(self, runtime)

        raise TypeError, 'top_left operand must be a cell address array' unless top_left.value.is_a?(Array)
        raise TypeError, 'bottom_right operand must be a cell address array' unless bottom_right.value.is_a?(Array)

        sum_value = loop_cells(top_left, bottom_right, "sum", runtime)
        Primitive.new(sum_value)
    end
end