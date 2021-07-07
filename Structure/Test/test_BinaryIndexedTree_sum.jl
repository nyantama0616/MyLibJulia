include("../binary_indexed_tree.jl")

using Test
using .MyBinaryIndexedTree

@testset "BinaryIndexedTree_sum" begin
    function test_interval_sums(tree::BinaryIndexedTree{T}) where T
        a = get_values(tree)
        len = length(a)
        dp = Array{T, 1}([0])
        for i in 1:len
            push!(dp, dp[i] + a[i])
        end
        popfirst!(dp)

        all(i -> calc_sum(tree, i) == dp[i], 1:len)
    end

    for i in 1:1000
        @testset "1~iまでの総和" begin
            rng = -10^3:10^3
            a = rand(rng, rand(10:100))
            tree = BinaryIndexedTree{Int}(a)
            set_interval_sum!(tree)

            len = length(a)
            for j in 1:10
                update_at!(tree, rand(1:len), rand(rng))
                increase_at!(tree, rand(1:len), rand(rng))
            end
            
            temp = test_interval_sums(tree) 
            
            if !temp
                println(a)
                println(get_interval_sums(tree))
            end

            @test temp
        end
    end
end
