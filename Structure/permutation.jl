include("./heap.jl")

module MyPermutation
    using ..MyHeap
    export Permutation, next!

    INT_MAX = 10^18

    mutable struct Permutation{T}
        ary::Array{T, 1}
        stack::Array{T, 1}
        heap::Heap{T}
        iscomplete::Bool
    end

    function Permutation{T}(ary::Array{T, 1}) where T
        stack = Array{T, 1}()
        push!(stack, 0)
        for x in ary
            push!(stack, x)
        end
        Permutation{T}(ary, stack, Heap{Int}(), false)
    end

    function next!(perm::Permutation{T}) where T
        if perm.iscomplete return end
        temp = copy(perm.stack)
        
        add!(perm.heap, pop!(perm.stack))
        num = [pop!(perm.stack) for _ in 1:2]

        while true
            t = find(num[1], perm.heap.cont)
            if t == INT_MAX
                if num[2] == 0 
                    perm.iscomplete = true
                    break 
                end
                add!(perm.heap, num[1])
                num[1] = num[2]
                num[2] = pop!(perm.stack)
            else
                add!(perm.heap, num[1])
                push!(perm.stack, num[2])
                push!(perm.stack, t)
                while true
                    x = remove!(perm.heap)
                    if isnothing(x) break end
                    if x == t continue end
                    push!(perm.stack, x)
                end
                break
            end
        end
        temp[2:end]
    end

    function find(x::T, ary::Array{T, 1}) where T
        result = INT_MAX
        for t in ary
            if t > x && t < result result = t end
        end
        result
    end
end
