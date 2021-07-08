include("../permutation.jl")
using Test
using Combinatorics
using .MyPermutation

@time @testset "Permutation" begin
    for i in 2:10
        @testset "n!の値" begin
            perm = Permutation{Int}([j for j in 1:i])
            cnt = 0
            while next!(perm) !== nothing
                cnt += 1
            end
            @test cnt == factorial(i)
        end
    end
end 
