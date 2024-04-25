# Name: Sayemum Hassan
# Date: 2/23/2024
# Description: The Lexer Class accepts expressions and tokenizes them into lists

class Lexer
    def initialize(source)
        @source = source
        @i = 0
        @tokens = []
        @token_so_far = ''
    end

    # Tells if index is in bound of the source text and if
    # the current character at the index is equal to the passed character.
    def has(char)
        @i < @source.length && @source[@i] == char
    end

    # Tells if the current character at the index
    # is a valid english letter and fits in the bounds of source text
    def has_letter
        @i < @source.length && ('a' <= @source[@i] && @source[@i] <= 'z') || ('A' <= @source[@i] && @source[@i] <= 'Z')
    end

    def has_digit
        @i < @source.length && '0' <= @source[@i] && @source[@i] <= '9'
    end

    # Get rid of the current token and move to next char
    def abandon
		@token_so_far = ''
		@i += 1
	end

    # Takes the current token so far and adds
    # the current character at the index to the token.
    # It also increments the index to the next character.
    def capture
        @token_so_far += @source[@i]
        @i += 1
    end

    # Adds the current token to the tokens array
    # and resets the current token to be empty.
    def emit_token(type)
        @tokens << Token.new(type, @token_so_far, @i - @token_so_far.length, @i - 1)
        @token_so_far = ''
    end

    # The main lexer function that loops through all characters
    # in the source and creates tokens.
    def lex
        while @i < @source.length
            if has('(') # Parenthesis (Casting)
				capture
				emit_token(:left_parenthesis)      
			elsif has(')')
				capture
				emit_token(:right_parenthesis)
            elsif has('#')
                capture
                emit_token(:pound)
            elsif has('[') # Brackets (Cell Address)
				capture
				emit_token(:left_bracket)
            elsif has(']')
				capture
				emit_token(:right_bracket)
            elsif has('{')
				capture
				emit_token(:left_curly)
            elsif has('}')
				capture
				emit_token(:right_curly)
            elsif has(',')
                capture
                emit_token(:comma)
            elsif has('.')
                capture
                if has('.')
                    capture
                    emit_token(:cell_range)
                else
                    abandon
                end
            elsif has_digit # Capture any digits
                while has_digit
                    capture
                end

                if has('.')
                    capture
                    while has_digit
                        capture
                    end
                    emit_token(:float)
                else
                    emit_token(:integer)
                end
            elsif has_letter # Capture words (cell address, boolean primitive, statistic functions)
                while has_letter
                    capture
                end

                if @token_so_far == 'true' || @token_so_far == 'false' # Boolean Primitive
                    emit_token(:boolean)
                elsif @token_so_far == 'float'
                    emit_token(:i_to_f)
                elsif @token_so_far == 'int'
                    emit_token(:f_to_i)
                elsif @token_so_far == 'max' # Statistic Func Names
                    emit_token(:max)
                elsif @token_so_far == 'min'
                    emit_token(:min)
                elsif @token_so_far == 'mean'
                    emit_token(:mean)
                elsif @token_so_far == 'sum'
                    emit_token(:sum)
                # Milestone 4
                elsif @token_so_far == 'if' # Condition
                    emit_token(:if)
                elsif @token_so_far == 'else'
                    emit_token(:else)
                elsif @token_so_far == 'end'
                    emit_token(:end)
                elsif @token_so_far == 'for' # Loop
                    emit_token(:for)
                elsif @token_so_far == 'in'
                    emit_token(:in)
                elsif @token_so_far == 'let'
                    emit_token(:let)
                else
                    #raise "Unidentified Word In Lexer: #{@source[@i]}"
                    emit_token(:identifier)
                end
            elsif has('"')
                capture
                while !has('"')
                    if @i >= @source.length # Check if the string is never closed
                        raise 'String never closed found in Lexer. Locate a String in source file and close with a double quote.'
                    end
                    capture
                end
                capture
                emit_token(:string)

            elsif has('<') # Relational
                capture
                if has('=')
                    capture
                    emit_token(:less_than_or_equal)
                elsif has('<') # Bitwise left shift
                    capture
                    emit_token(:left_shift)
                else
                    emit_token(:less_than)
                end
            elsif has('>')
                capture
                if has('=')
                    capture
                    emit_token(:greater_than_or_equal)
                elsif has('>') # Bitwise right shift
                    capture
                    emit_token(:right_shift)
                else
                    emit_token(:greater_than)
                end
            elsif has('=')
                capture
                if has('=')
                    capture
                    emit_token(:equals)
                else
                    #raise "No assignment operator allowed (=), expressions only."
                    capture
                    emit_token(:assignment) # Milestone 4
                end
            elsif has('!') # Not Equals OR Not Logical
                capture
                if has('=')
                    capture
                    emit_token(:not_equals)
                else
                    emit_token(:not_logical)
                end

            elsif has('+') # Arithmetics
                capture
                emit_token(:add)
            elsif has('-') # Subtract OR Negation
                capture
                emit_token(:hyphen)
            elsif has('*') # Multiply OR exponent
                capture
                if has('*')
                    capture
                    emit_token(:exponent)
                else
                    emit_token(:multiply)
                end
            elsif has('/')
                capture
                emit_token(:divide)
            elsif has('%')
                capture
                emit_token(:modulo)

            elsif has('&') # Bitwise AND Logical
                capture
                if has('&')
                    capture
                    emit_token(:and_logical)
                else
                    emit_token(:and_bitwise)
                end
            elsif has('|')
                capture
                if has('|')
                    capture
                    emit_token(:or_logical)
                else
                    emit_token(:or_bitwise)
                end
            elsif has('^')
                capture
                emit_token(:xor_bitwise)
            elsif has('~')
                capture
                emit_token(:not_bitwise)
            elsif has(' ') || has("\n") # Skip whitespace
                abandon
            else
                raise "Unidentified Character In Lexer: #{@source[@i]}"
            end
        end

        @tokens
    end
end