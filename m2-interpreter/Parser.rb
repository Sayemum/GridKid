# Name: Sayemum Hassan
# Date: 2/25/2024
# Description: The Parser Class accepts a list of tokens and assembles abstract syntax trees using the model abstractions from m1-model

require_relative('../m1-model/Abstractions/Primitive.rb')
require_relative('../m1-model/Abstractions/Arithmetic.rb')
require_relative('../m1-model/Abstractions/Bitwise.rb')
require_relative('../m1-model/Abstractions/Casting.rb')
require_relative('../m1-model/Abstractions/Logical.rb')
require_relative('../m1-model/Abstractions/Relational.rb')
require_relative('../m1-model/Abstractions/Statistic.rb')
require_relative('../m1-model/Abstractions/CellValue.rb')
require_relative('../m1-model/Abstractions/UnaryOperator.rb')

require_relative('../m1-model/Abstractions/Assignment.rb')
require_relative('../m1-model/Abstractions/Block.rb')
require_relative('../m1-model/Abstractions/Conditional.rb')
require_relative('../m1-model/Abstractions/ForEachLoop.rb')
require_relative('../m1-model/Abstractions/VariableReference.rb')

class Parser
    def initialize(tokens)
		@tokens = tokens
		@i = 0
	end

    # Tells if index is in bound of the tokens array and if
    # the current token's type at the index is equal to the passed type.
    def has(type)
		@i < @tokens.size && @tokens[@i].type == type
	end

    # Increment the index and return the current token
	def advance
		@i += 1
		@tokens[@i - 1]
	end

    # The main parser function (starts at root)
=begin
PARSE NOTES TODO:
1. putting down multiple empty newlines will throw an error
2. Figure out how to recurse blocks in 'if-else-end' statement


1. 
=end
    def parse
        if @tokens.length == 0 # Check if there's no tokens to go through
            raise "There's no tokens to parse in this line. Consider removing this line from the source file."
        end

        #logical_expr
        statements = []

        while @i < @tokens.size
            case @tokens[@i].type
            when :let
                statements << parse_var_assign
            when :if
                statements << parse_if_statement
            when :for
                statements << parse_for_loop
            # Add more cases for other constructs like :for
            when :right_curly
                break
            else
                statements << logical_expr # Default case for expressions
            end
        end

        Block.new(statements)
    end

    def parse_var_assign
        let_keyword = advance # skip 'let'
        identifier = advance
        raise "Expected an identifier in variable assignment." unless identifier.type == :identifier
        
        assignment = advance # equals_keyword
        raise "Expected '=' in variable assignment." unless assignment.type == :assignment
        value_expr = logical_expr
        
        Assignment.new(Primitive.new(identifier.text), value_expr, let_keyword.start_index, value_expr.end_index)
    end

    def parse_if_statement
        if_keyword = advance # Skip 'if'
        raise "Expected '(' in if statement." unless has(:left_parenthesis)
        advance

        condition_expr = logical_expr
        
        raise "Expected ')' in if statement." unless has(:right_parenthesis)
        advance

        while @tokens[@i].type != :left_curly # skip 'then' block
            advance
        end

        raise "Expected '{' in if statement." unless has(:left_curly)
        advance
        
        then_block = parse
        advance

        raise "Expected 'else' in if statement." unless @tokens[@i].type == :else
        advance
        
        raise "Expected '{' in if statement." unless has(:left_curly)
        advance

        else_block = parse
        
        right_bracket = @tokens[@i]
        advance

        Conditional.new(condition_expr, then_block, else_block, if_keyword.start_index, right_bracket.end_index)
    end

    def parse_for_loop
        for_keyword = advance # Skip 'for'
        identifier = advance # identifier
        raise "Expected an identifier in for-each loop." unless identifier.type == :identifier

        in_keyword = advance # in-keyword
        raise "Expected 'in' in for-each loop." unless in_keyword.type == :in

        top_left_addr = logical_expr
        cell_range_keyword = advance
        raise "Expected '..' in for-each loop." unless cell_range_keyword.type == :cell_range
        bottom_right_addr = logical_expr

        raise "Expected '{' in if statement." unless has(:left_curly)
        advance

        for_block = parse

        ForEachLoop.new(Primitive.new(identifier.text), top_left_addr, bottom_right_addr, for_block, for_keyword.start_index, advance.end_index)
    end

    def logical_expr
        left = bitwise_expr

        while has(:and_logical) || has(:or_logical)
            if has(:and_logical)
                advance
                right = bitwise_expr
                left = Logical::AndLogical.new(left, right, left.start_index, right.end_index)
            elsif has(:or_logical)
                advance
                right = bitwise_expr
                left = Logical::OrLogical.new(left, right, left.start_index, right.end_index)
            end
        end
        left
    end

    def bitwise_expr
        left = equality_expr

        while has(:and_bitwise) || has(:or_bitwise) || has(:xor_bitwise) || has(:left_shift) || has(:right_shift)
            if has(:and_bitwise)
                advance
                right = equality_expr
                left = Bitwise::AndBitwise.new(left, right, left.start_index, right.end_index)
            elsif has(:or_bitwise)
                advance
                right = equality_expr
                left = Bitwise::OrBitwise.new(left, right, left.start_index, right.end_index)
            elsif has(:xor_bitwise)
                advance
                right = equality_expr
                left = Bitwise::XorBitwise.new(left, right, left.start_index, right.end_index)
            elsif has(:left_shift)
                advance
                right = equality_expr
                left = Bitwise::LeftShift.new(left, right, left.start_index, right.end_index)
            elsif has(:right_shift)
                advance
                right = equality_expr
                left = Bitwise::RightShift.new(left, right, left.start_index, right.end_index)
            else
                raise "Unexpected bitwise token: #{token.text}"
            end
        end
        left
    end

    def equality_expr
        left = relational_expr

        while has(:equals) || has(:not_equals)
            if has(:equals)
                advance
                right = relational_expr
                left = Relational::Equals.new(left, right, left.start_index, right.end_index)
            elsif has(:not_equals)
                advance
                right = relational_expr
                left = Relational::NotEquals.new(left, right, left.start_index, right.end_index)
            else
                raise "Unexpected equality token: #{token.text}"
            end
        end
        left
    end

    def relational_expr
        left = add_expr

        while has(:less_than) || has(:less_than_or_equal) || has(:greater_than) || has(:greater_than_or_equal)
            if has(:less_than)
                advance
                right = add_expr
                left = Relational::LessThan.new(left, right, left.start_index, right.end_index)
            elsif has(:less_than_or_equal)
                advance
                right = add_expr
                left = Relational::LessThanOrEqual.new(left, right, left.start_index, right.end_index)
            elsif has(:greater_than)
                advance
                right = add_expr
                left = Relational::GreaterThan.new(left, right, left.start_index, right.end_index)
            elsif has(:greater_than_or_equal)
                advance
                right = add_expr
                left = Relational::GreaterThanOrEqual.new(left, right, left.start_index, right.end_index)
            else
                raise "Unexpected relational token: #{token.text}"
            end
        end
        left
    end

    def add_expr
        left = mul_expr

        while has(:add) || has(:hyphen)
            if has(:add)
                advance
                right = mul_expr
                left = Arithmetic::Add.new(left, right, left.start_index, right.end_index)
            elsif has(:hyphen)
                advance
                right = mul_expr
                left = Arithmetic::Subtract.new(left, right, left.start_index, right.end_index)
            else
                raise "Unexpected additive token: #{token.text}"
            end
        end
        left
    end

    def mul_expr
        left = unary_expr

        while has(:multiply) || has(:divide) || has(:modulo)
            if has(:multiply)
                advance
                right = unary_expr
                left = Arithmetic::Multiply.new(left, right, left.start_index, right.end_index)
            elsif has(:divide)
                advance
                right = unary_expr
                left = Arithmetic::Divide.new(left, right, left.start_index, right.end_index)
            elsif has(:modulo)
                advance
                right = unary_expr
                left = Arithmetic::Modulo.new(left, right, left.start_index, right.end_index)
            else
                raise "Unexpected multiplicative token: #{token.text}"
            end
        end
        left
    end

    def unary_expr
        if has(:hyphen) || has(:not_logical) || has(:not_bitwise) || has(:f_to_i) || has(:i_to_f)
            
            if has(:hyphen)
                token = advance
                operand = unary_expr
                Arithmetic::Negate.new(operand, token.start_index, operand.end_index)
            elsif has(:not_logical)
                token = advance
                operand = unary_expr
                Logical::NotLogical.new(operand, token.start_index, operand.end_index)
            elsif has(:not_bitwise)
                token = advance
                operand = unary_expr
                Bitwise::NotBitwise.new(operand, token.start_index, operand.end_index)
            elsif has(:f_to_i)
                token = advance
                operand = unary_expr
                Casting::FloatToInt.new(operand, token.start_index, operand.end_index)
            elsif has(:i_to_f)
                token = advance
                operand = unary_expr
                Casting::IntToFloat.new(operand, token.start_index, operand.end_index)
            else
                raise "Unexpected unary token: #{token.text}"
            end
        else
            power
        end
    end

    def power
        left = primary

        while has(:exponent)
            token = advance
            right = power
            left = Arithmetic::Exponent.new(left, right, left.start_index, right.end_index)
        end
        left
    end

    def primary
        if has(:left_parenthesis) # ( expression )
            advance
            expr = logical_expr
            raise "Expected ')' after expression." unless has(:right_parenthesis)
            advance
            expr
        elsif has(:integer)
            token = advance
            Primitive.new(token.text.to_i, token.start_index, token.end_index)
        elsif has(:float)
            token = advance
            Primitive.new(token.text.to_f, token.start_index, token.end_index)
        elsif has(:boolean)
            token = advance
            if token.text == "true"
                Primitive.new(true, token.start_index, token.end_index)
            else
                Primitive.new(false, token.start_index, token.end_index)
            end
        elsif has(:string)
            token = advance
            Primitive.new(token.text, token.start_index, token.end_index)
        elsif has(:identifier) # MILESTONE 4
            token = advance
            VariableReference.new(token.text, token.start_index, token.end_index)
        elsif has(:left_bracket)
            advance
            left_expr = logical_expr
            raise "Expected ',' in cell address." unless has(:comma)
            advance

            right_expr = logical_expr
            raise "Expected ']' after cell address." unless has(:right_bracket)
            advance

            Primitive.new([left_expr.value, right_expr.value], left_expr.start_index, right_expr.end_index)

        
        elsif has(:pound) # r-value
            advance # Consume the pound symbol '#'
    
            raise "Expected '[' after '#'" unless has(:left_bracket)
            advance
            
            x_expr = logical_expr # Parse the x coordinate expression
            
            raise "Expected ',' separating cell address values" unless has(:comma)
            advance
            
            y_expr = logical_expr # Parse the y coordinate expression
            
            raise "Expected ']' to close cell address" unless has(:right_bracket)
            advance

            CellValue::CellRValue.new(x_expr, y_expr, x_expr.start_index, y_expr.end_index)

        elsif has(:max) || has(:min) || has(:mean) || has(:sum) # function call
            function_call
        else
            raise "Unexpected token in primary: #{token.text}"
        end
    end


    def function_call
        function_name_token = advance # Consume the function name token
        advance # Consume the opening '('

        # Expect the opening bracket '['
        raise "Expected '[' after function name." unless has(:left_bracket)
        advance

        # Parse the first pair of expressions as arguments
        first_expr = logical_expr
        raise "Expected ',' in function arguments." unless has(:comma)
        advance

        second_expr = logical_expr
        raise "Expected ']' after arguments." unless has(:right_bracket)
        advance

        # Expect a comma between the pairs of arguments
        raise "Expected ',' between argument pairs." unless has(:comma)
        advance

        # Repeat the argument parsing for the second pair
        raise "Expected '[' for second pair of arguments." unless has(:left_bracket)
        advance

        third_expr = logical_expr
        raise "Expected ',' in function arguments." unless has(:comma)
        advance

        fourth_expr = logical_expr
        raise "Expected ']' after arguments." unless has(:right_bracket)
        advance

        # Finally, expect the closing ')' of the function call
        raise "Expected ')' after function arguments." unless has(:right_parenthesis)
        advance

        top_left = Primitive.new([first_expr.value, second_expr.value], first_expr.start_index, second_expr.end_index)
        bottom_right = Primitive.new([third_expr.value, fourth_expr.value], third_expr.start_index, fourth_expr.end_index)


        # Create the correct statistic function object
        case function_name_token.text
        when "max"
            Statistic::Max.new(top_left, bottom_right, top_left.start_index, bottom_right.end_index)
        when "min"
            Statistic::Min.new(top_left, bottom_right, top_left.start_index, bottom_right.end_index)
        when "mean"
            Statistic::Mean.new(top_left, bottom_right, top_left.start_index, bottom_right.end_index)
        when "sum"
            Statistic::Sum.new(top_left, bottom_right, top_left.start_index, bottom_right.end_index)
        else
            raise "Unexpected function_name_token in parser function_call(): #{function_name_token.text}"
        end
    end
end