# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The main script for milestone 1

require_relative('Abstractions/Primitive.rb')
require_relative('Abstractions/Arithmetic.rb')
require_relative('Abstractions/Bitwise.rb')
require_relative('Abstractions/Casting.rb')
require_relative('Abstractions/Logical.rb')
require_relative('Abstractions/Relational.rb')
require_relative('Abstractions/Statistic.rb')
require_relative('Abstractions/CellValue.rb')
require_relative('Abstractions/UnaryOperator.rb')

require_relative('Serializer.rb')
require_relative('Evaluator.rb')
require_relative('Grid.rb')
require_relative('Runtime.rb')

#Grid Runtime
grid = Grid.new
#runtime = Runtime.new(grid)


def populate_grid(grid)
    # [0,0]      1 + 1       2
    grid.set_cell(Primitive.new([0, 0]), "1 + 1", Arithmetic::Add.new(Primitive.new(1), Primitive.new(1)))

    # [0,1]      5 * 5       25
    grid.set_cell(Primitive.new([0, 1]), "5 * 5", Arithmetic::Multiply.new(Primitive.new(5), Primitive.new(5)))

    # [0,2]      10 << 5 - 10       310
    grid.set_cell(Primitive.new([0, 2]), "10 << 5 - 10", Arithmetic::Subtract.new(Bitwise::LeftShift.new(Primitive.new(10), Primitive.new(5)), Primitive.new(10)))

    # [0,3]      !(10 % 2 == 1)       true
    grid.set_cell(Primitive.new([0, 3]), "!(10 % 2 == 1)", Logical::NotLogical.new(Relational::Equals.new(Arithmetic::Modulo.new(Primitive.new(10), Primitive.new(2)), Primitive.new(1))))
end


populate_grid(grid)
#puts grid.get_primitive(Primitive.new(0, 3)).value


# NEGATE TEST
=begin
ast = Arithmetic::Negate.new(Primitive.new(10, 1, 1), 1, 1)
primitive = ast.traverse(Evaluator.new, runtime)
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"
#Serialize
text = ast.traverse(Serializer.new, runtime)
puts "Serializer Text: #{text}"
puts
=end


# 1.) Arithmetic Example: (7 * 4 + 3) % 12 = 7
puts "####################################### EXAMPLE 1: (7 * 4 + 3) % 12 = 7 #######################################"
ast = Arithmetic::Modulo.new(
    Arithmetic::Add.new(
        Arithmetic::Multiply.new(Primitive.new(7), Primitive.new(4)),

        Primitive.new(3)
    ),
    Primitive.new(12)
)

#Evaluator
primitive = ast.traverse(Evaluator.new, Runtime.new(grid))
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"
#Serialize
text = ast.traverse(Serializer.new, Runtime.new(grid))
puts "Serializer Text: #{text}"
puts




# 2.) Rvalue lookup and shift: #[1 + 1, 4] << 3
puts "####################################### EXAMPLE 2: #[1 + 1, 4] << 3 = 8 #######################################"
grid.set_cell(Primitive.new([2, 4]), '1', Primitive.new(1))
ast = Bitwise::LeftShift.new(
    CellValue::CellRValue.new(
        Arithmetic::Add.new(Primitive.new(1), Primitive.new(1)),

        Primitive.new(4)
    ),

    Primitive.new(3)
)

#Evaluator
primitive = ast.traverse(Evaluator.new, Runtime.new(grid))
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"
#Serialize
text = ast.traverse(Serializer.new, Runtime.new(grid))
puts "Serializer Text: #{text}"
puts



# 3.) Rvalue lookup and comparison: #[0, 0] < #[0, 1]
puts "####################################### EXAMPLE 3: #[0, 0] < #[0, 1] = true #######################################"
grid.set_cell(Primitive.new([0, 0]), "1", Primitive.new(1))
grid.set_cell(Primitive.new([0, 1]), "2", Primitive.new(2))

ast = Relational::LessThan.new(
    CellValue::CellRValue.new(Primitive.new(0), Primitive.new(0)),
    CellValue::CellRValue.new(Primitive.new(0), Primitive.new(1))
)

primitive = ast.traverse(Evaluator.new, Runtime.new(grid))
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"
#Serialize
text = ast.traverse(Serializer.new, Runtime.new(grid))
puts "Serializer Text: #{text}"
puts



# 4.) Logic and comparison: !(3.3 > 3.2)
puts "####################################### EXAMPLE 4: #[0, 0] < #[0, 1] = true #######################################"
ast = Logical::NotLogical.new(
    Relational::GreaterThan.new(
        Primitive.new(3.1),
        Primitive.new(3.2)
    )
)

primitive = ast.traverse(Evaluator.new, Runtime.new(grid))
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"
#Serialize
text = ast.traverse(Serializer.new, Runtime.new(grid))
puts "Serializer Text: #{text}"
puts



# 5.) Sum: sum([1, 2], [5, 3])
puts "####################################### EXAMPLE 5: sum([1, 2], [5, 3]) = 4 #######################################"

grid.set_cell(Primitive.new([0, 0]), "1", Primitive.new(1))
grid.set_cell(Primitive.new([0, 1]), "1", Primitive.new(1))
grid.set_cell(Primitive.new([0, 2]), "1", Primitive.new(1))
grid.set_cell(Primitive.new([0, 3]), "1", Primitive.new(1))


ast = Statistic::Sum.new(
    CellValue::CellLValue.new(Primitive.new(0), Primitive.new(0)),
    CellValue::CellLValue.new(Primitive.new(0), Primitive.new(3))
)

primitive = ast.traverse(Evaluator.new, Runtime.new(grid))
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"
#Serialize
text = ast.traverse(Serializer.new, Runtime.new(grid))
puts "Serializer Text: #{text}"
puts



# 6.) Casting Example: float(7) / 2
puts "####################################### EXAMPLE 6: float(7) / 2 = 3.5 #######################################"

ast = Arithmetic::Divide.new(
    Casting::IntToFloat.new(Primitive.new(7)),
    Primitive.new(2)
)

primitive = ast.traverse(Evaluator.new, Runtime.new(grid))
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"
#Serialize
text = ast.traverse(Serializer.new, Runtime.new(grid))
puts "Serializer Text: #{text}"
puts



# BONUS 7.) Max Example: max([2,0], [2,5])
puts "####################################### BONUS EXAMPLE 7: max([2,0], [2,4]) #######################################"
grid.set_cell(Primitive.new([2, 0]), "2 * 4", Arithmetic::Multiply.new(Primitive.new(2), Primitive.new(4)))
grid.set_cell(Primitive.new([2, 1]), "0", Primitive.new(0))
grid.set_cell(Primitive.new([2, 2]), "10 - 4", Arithmetic::Subtract.new(Primitive.new(10), Primitive.new(4)))
grid.set_cell(Primitive.new([2, 3]), "3", Primitive.new(3))
grid.set_cell(Primitive.new([2, 4]), "9", Primitive.new(9))

ast = Statistic::Max.new(
    CellValue::CellLValue.new(Primitive.new(2), Primitive.new(0)),
    CellValue::CellLValue.new(Primitive.new(2), Primitive.new(4))
)

primitive = ast.traverse(Evaluator.new, Runtime.new(grid))
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"
#Serialize
text = ast.traverse(Serializer.new, Runtime.new(grid))
puts "Serializer Text: #{text}"
puts


# BONUS 8.) Arithmetic Broken Example: false + 5
=begin
puts "####################################### BONUS BROKEN EXAMPLE 8: false + 5 #######################################"
runtime.set_cell(Primitive.new(3, 0), "2", Primitive.new(2))
runtime.set_cell(Primitive.new(3, 1), "5", Primitive.new(5))

ast = Arithmetic::Add.new(
    CellValue::CellRValue.new(Primitive.new(3), Primitive.new(0)),
    CellValue::CellRValue.new(Primitive.new(3), Primitive.new(1))
)

primitive = ast.traverse(Evaluator.new, runtime)
puts "Evaluator Primitive: #{primitive}"
puts "Evaluator Primitive Value: #{primitive.value}"
#Serialize
text = ast.traverse(Serializer.new, runtime)
puts "Serializer Text: #{text}"
puts
=end