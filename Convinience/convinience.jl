# ---便利メソッド集---


# -Rubyのパクリ-

function tally(a::Array{T, 1}) where T
    result = Dict{T, Int}()
    sort!(a)
    len = length(a)
    i = 1
    while i <= len
        temp = a[i]
        j = 1
        while i + j <= len && a[i + j] == temp
            j += 1
        end
        result[temp] = j
        i += j
    end
    result
end
