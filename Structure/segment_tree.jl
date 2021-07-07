module MySegmentTree
    INT_MAX = 10^18
    export SegmentTree, get_values, get_segs, get_mins,
           calc_min, update_at!, increase_at!
    mutable struct Node{T}
        seg::Array{Int,1}
        value::T
    end

    mutable struct SegmentTree{T}  
        segs::Array{Node{T}, 1}
        d::Int
        len::Int
        len_a::Int
    end

    function SegmentTree{T}(a::Array{T, 1}) where T 
        d = Int(ceil(log2(length(a)))) + 1
        len = 2^d - 1
        segs = [Node{T}([0, 0], INT_MAX) for i in 1:len]
        j = 2^(d - 1) - 1
        for i in 1:length(a)
            segs[i + j].value = a[i]
        end
        
        for i in 1:len - j
            segs[i + j].seg = [i, i]
        end

        for i in len:-1:2
            node = segs[i]
            par = segs[i ÷ 2]
            if (par.value > node.value) par.value = node.value end
            j = i % 2 + 1
            par.seg[j] = node.seg[j]
        end

        SegmentTree(segs, d, len, length(a))
    end

    function get_segs(tree::SegmentTree{T}) where T
        map(node -> node.seg, tree.segs)
    end
    
    function get_mins(tree::SegmentTree{T}) where T
        map(node -> node.value, tree.segs)
    end

    function calc_min(tree::SegmentTree{T}, a::Int, b::Int) where T
        calc_min(tree.segs, a, b, 1)
    end

    function calc_min(segs::Array{Node{T}, 1}, a::Int, b::Int, i::Int) where T
        node = segs[i]
        left, right = node.seg[:]

        a_check  = left <= a <= right
        b_check  = left <= b <= right 
        left_check = a <= left <= b
        right_check = a <= right <= b

        if left_check && right_check
            return node.value
        elseif a_check || b_check
            num1 = calc_min(segs, a, b, 2i)
            num2 = calc_min(segs, a, b, 2i + 1)
            return num1 < num2 ? num1 : num2
        else
            return INT_MAX
        end
    end

    function update_at!(tree::SegmentTree{T}, i::Int, x::T) where T
        j = i + 2^(tree.d - 1) - 1
        segs = tree.segs
        segs[j].value = x

        j ÷= 2
        while j > 0
            segs[j].value = segs[2j].value < segs[2j + 1].value ? segs[2j].value : segs[2j + 1].value
            j ÷= 2
        end
    end

    function increase_at!(tree::SegmentTree{T}, i::Int, x::T) where T
        update_at!(tree, i, tree.segs[i + 2^(tree.d - 1) - 1].value + x)
    end

    function get_values(tree::SegmentTree{T}) where T
        i = 2^(tree.d - 1)
        map(i -> tree.segs[i].value, i:i + tree.len_a - 1)
    end
end
