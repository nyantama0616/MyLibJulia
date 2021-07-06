# 約数全列挙
function make_divisors(x::Int)
    ary1 = Array{Int, 1}()
    ary2 = Array{Int, 1}()
    d = sqrt(x)
    i = 1
    while i <= d
        if x % i == 0
            push!(ary1, i)
            pushfirst!(ary2, x ÷ i)
        end
        i += 1
    end
    if (ary1[end] == ary2[begin]) pop!(ary1) end #uniq!
    append!(ary1, ary2)
end

# x以下の素数を全列挙
function make_primes(x::Int)
    result = Array{Int}([])
    flag = [true for i in 1:x]
    i = 2
    while i <= x
        if flag[i]
            push!(result, i)
            for j in 2i:i:x
                flag[j] = false
            end
        end
        i += 1
    end
    result
end

# 冪剰余(a^b % c)を求める(余りの周期性とかもちょっとイジれば返せる)
function pow(a::Int, b::Integer, c::Int)
    ary = Array{Int}([a % c])
    i = 2
    while i <= b
        temp = ary[end] * a % c
        if temp == ary[begin]
            break
        else
            push!(ary, temp)
        end
        i += 1
    end
    len = length(ary)
    ary[(b - 1) % len + 1]
end

# ユークリッド距離、またはマンハッタン距離を求める
function dist(a::Array{Int, 1}, b::Array{Int, 1}; mh = false)
    if mh
        abs(a[1] - b[1]) + abs(a[2] - b[2])
    else
        hypot(abs(a[1] - b[1]), abs(a[2] - b[2]))
    end
end



#= TODO:
    combinations() /// conbinatoricsは競プロで使えない
    permutations()
    
=#
