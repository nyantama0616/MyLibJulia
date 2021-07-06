#=
    ヒープ構造を用いて、
    昇順ソートと降順ソートがうまく機能するかテストする。
    Int型しかテストしてない。
=#

include("../structure.jl")
using Test
using .MyHeap

@testset "Heap_test" begin
    function heap_sort(a::Array{T, 1}; lt=isless) where T
        heap = Heap{T}(lt=lt)
        result = Array{T, 1}()
        len = length(a)
        for x in a
            add!(heap, x)
        end

        for i in 1:len
            push!(result, remove!(heap))
        end

        result
    end

    for i in 1:1000
        @testset "昇順ヒープ" begin 
            a = rand(-10^3:10^3, 100)
            result = heap_sort(a)
            len = length(a)
            
            temp = all(i -> result[i - 1] <= result[i], 2:len)
            if !temp
                println(a)
                println(result)
            end
            @test temp
        end
    end
    
    for i in 1:1000
        @testset "降順ヒープ" begin 
            a = rand(-10^3:10^3, 100)
            result = heap_sort(a, lt = (x, y) -> x > y)
            len = length(a)
            
            temp = all(i -> result[i - 1] >= result[i], 2:len)
            if !temp
                println(a)
                println(result)
            end
            @test temp
        end
    end
    
end
