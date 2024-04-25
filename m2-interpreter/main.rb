# Name: Sayemum Hassan
# Date: 2/23/2024
# Description: The main script for milestone 2

require_relative('Token.rb')
require_relative('Lexer.rb')
require_relative('Parser.rb')
require_relative('../m1-model/Evaluator.rb')
require_relative('../m1-model/Serializer.rb')
require_relative('../m1-model/Runtime.rb')
require_relative('../m1-model/Grid.rb')
require_relative('../m1-model/Abstractions/Primitive.rb')

#Grid Runtime
grid = Grid.new
#runtime = Runtime.new(grid)
#grid.set_runtime(runtime)

def populate_grid(grid)
    # [0,0]      1 + 1       2
    grid.set_cell(Primitive.new([0, 0]), "1 + 1", Arithmetic::Add.new(Primitive.new(1), Primitive.new(1)))

    # [0,1]      5 * 5       25
    grid.set_cell(Primitive.new([0, 1]), "5 * 5", Arithmetic::Multiply.new(Primitive.new(5), Primitive.new(5)))

    # [0,2]      10 << 5 - 10       310
    grid.set_cell(Primitive.new([0, 2]), "10 << 5 - 10", Arithmetic::Subtract.new(Bitwise::LeftShift.new(Primitive.new(10), Primitive.new(5)), Primitive.new(10)))

    # [0,3]      !(10 % 2 == 1)       true
    grid.set_cell(Primitive.new([0, 3]), "!(10 % 2 == 1)", Logical::NotLogical.new(Relational::Equals.new(Arithmetic::Modulo.new(Primitive.new(10), Primitive.new(2)), Primitive.new(1))))

    # [0,4]      1 + 1       2
    grid.set_cell(Primitive.new([0, 4]), "1 + 1", Arithmetic::Add.new(Primitive.new(1), Primitive.new(1)))
    
    grid.set_cell(Primitive.new([0, 7]), "20 / 2", Arithmetic::Divide.new(Primitive.new(20), Primitive.new(2)))
    grid.set_cell(Primitive.new([0, 5]), "1 + 1", Arithmetic::Add.new(Primitive.new(1), Primitive.new(1)))
    grid.set_cell(Primitive.new([0, 6]), "10 ** 1", Arithmetic::Exponent.new(Primitive.new(10), Primitive.new(1)))
    grid.set_cell(Primitive.new([0, 8]), "float(6)", Casting::IntToFloat.new(Primitive.new(6)))
    grid.set_cell(Primitive.new([0, 9]), "int(3.0)", Casting::FloatToInt.new(Primitive.new(3.0)))
    grid.set_cell(Primitive.new([1, 0]), "5 < 2", Relational::LessThan.new(Primitive.new(5), Primitive.new(2)))
    grid.set_cell(Primitive.new([1, 1]), "int(12.0)", Casting::FloatToInt.new(Primitive.new(12.0)))
    grid.set_cell(Primitive.new([1, 2]), "100 >= 10", Relational::GreaterThanOrEqual.new(Primitive.new(100), Primitive.new(10)))
    grid.set_cell(Primitive.new([1, 3]), "50 <= 20", Relational::LessThanOrEqual.new(Primitive.new(50), Primitive.new(20)))
    grid.set_cell(Primitive.new([1, 4]), "1 == 1", Relational::Equals.new(Primitive.new(1), Primitive.new(1)))
    grid.set_cell(Primitive.new([1, 5]), "1 != 1", Relational::NotEquals.new(Primitive.new(1), Primitive.new(1)))
    grid.set_cell(Primitive.new([1, 6]), "100 >> 2", Bitwise::RightShift.new(Primitive.new(100), Primitive.new(2)))
    grid.set_cell(Primitive.new([1, 7]), "~100", Bitwise::NotBitwise.new(Primitive.new(100)))
    grid.set_cell(Primitive.new([1, 8]), "5 & 5", Bitwise::AndBitwise.new(Primitive.new(5), Primitive.new(5)))
    grid.set_cell(Primitive.new([1, 9]), "min([0,5], [1,0])", Statistic::Min.new(CellValue::CellLValue.new(Primitive.new(0), Primitive.new(5)), CellValue::CellLValue.new(Primitive.new(0), Primitive.new(9))))
    grid.set_cell(Primitive.new([2, 0]), "#[0, 4]", CellValue::CellRValue.new(Primitive.new(0), Primitive.new(4)))
    grid.set_cell(Primitive.new([2, 1]), "true && false", Logical::AndLogical.new(Primitive.new(true), Primitive.new(false)))

    # M3 Update R-Cell Refresh
    grid.set_cell(Primitive.new([0, 4]), "1 + 10", Arithmetic::Add.new(Primitive.new(1), Primitive.new(10)))
    grid.set_cell(Primitive.new([2, 2]), "10", Primitive.new(10))
end

populate_grid(grid)

#source_lines = File.readlines("GridKid/m2-interpreter/expression.txt")
source = File.read("GridKid/m2-interpreter/expression.txt")

#source_lines.each do |source_line|
lexer = Lexer.new(source)

tokens = lexer.lex
tokens.each { |token| puts token.inspect }


parser = Parser.new(tokens)
ast = parser.parse
puts
puts ast.inspect
puts

#Evaluator
runtime_cell = grid.get_cell(Primitive.new([0,0]))

primitive = ast.traverse(Evaluator.new, runtime_cell.runtime)
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"

#Serialize
text = ast.traverse(Serializer.new, runtime_cell.runtime)
puts "\nSerializer Text:\n#{text}\n"

#puts
#puts "----------------------------------------------------------------------------------------------"
#puts
#end
