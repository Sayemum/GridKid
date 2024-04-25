# Name: Sayemum Hassan
# Date: 2/5/2024
# Description: The Statistics Module that contains all 4 statistics types

module Statistic
    module Initializable
        attr_reader :top_left, :bottom_right, :start_index, :end_index

        def initialize(top_left, bottom_right, start_index=-1, end_index=-1)
            @top_left = top_left
            @bottom_right = bottom_right
            @start_index = start_index
            @end_index = end_index
        end
    end

    class Max
        include Initializable

        def traverse(visitor, payload)
            visitor.visit_max(self, payload)
        end
    end

    class Min
        include Initializable

        def traverse(visitor, payload)
            visitor.visit_min(self, payload)
        end
    end

    class Mean
        include Initializable

        def traverse(visitor, payload)
            visitor.visit_mean(self, payload)
        end
    end

    class Sum
        include Initializable

        def traverse(visitor, payload)
            visitor.visit_sum(self, payload)
        end
    end
end

