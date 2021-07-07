include("../segment_tree.jl")
using Test
using .MySegmentTree
using Base: Bool

@testset "SegmentTree" begin
    for s in 1:100
        # 更新・インクリメントを繰り返しても正しいく動作するか。
        @testset "レベル4" begin
            function calc(ary::Array{Int, 1}, a::Int, b::Int)
                result = 10^18
                for i in a:b
                    if result > ary[i] result = ary[i] end
                end
                result
            end

            a = rand(-10^3:10^3, 10^3)
            tree = SegmentTree{Int}(a)

            for i in 1:10^2
                j = rand(1:length(a), 2)
                x = rand(-10:10, 2)
                update_at!(tree, j[1], x[1])
                increase_at!(tree, j[2], x[2])
            end

            for i in 1:10^2
                a, b = sort(rand(1:length(a), 2))
                @test calc_min(tree, a, b) == calc(get_values(tree), a, b)
            end
        end
    end
end
