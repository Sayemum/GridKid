# Name: Sayemum Hassan
# Date: 3/30/2024
# Description: The Variable Reference Module that contains a variable treated as an R-Value

class VariableReference
    include UnaryOperator

    def traverse(visitor, payload)
        visitor.visit_var_reference(self, payload)
    end
end