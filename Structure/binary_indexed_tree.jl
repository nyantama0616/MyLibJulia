# BIT
module MyBinaryIndexedTree
    export Node, BinaryIndexedTree, get_values, get_interval_sums
    export set_interval_sum!, update_at!, increase_at!, calc_sum, show_detail
    # ノード
    mutable struct Node{T}
        value::T
        interval_sum::T
        lsb::Int
    end

    # ノード用コンストラクタ
    function Node{T}(value::T, i::Int) where T
        Node{T}(value, 0, i & -i)
    end

    struct BinaryIndexedTree{T}
        bits::Array{Node, 1}
        len::Int
    end

    # BIT用コンストラクタ
    function BinaryIndexedTree{T}(a::Array{T, 1}) where T
        len = length(a)
        bits = [Node{T}(a[i], i) for i in 1:len]
        BinaryIndexedTree{T}(bits, len)
    end

    function get_values(tree::BinaryIndexedTree{T}) where T
        map(node -> node.value, tree.bits)
    end
    
    function get_interval_sums(tree::BinaryIndexedTree{T}) where T
        map(node -> node.interval_sum, tree.bits)
    end

    # すべての区間和を計算
    function set_interval_sum!(tree::BinaryIndexedTree{T}) where T
        bits = tree.bits
        len = tree.len
        for i in 1:len
            node1 = bits[i]
            node1.interval_sum = node1.value

            j = i - 1
            k = i - node1.lsb
            while j > k
                node2 = bits[j]
                node1.interval_sum += node2.interval_sum
                j -= node2.lsb
            end

        end
    end

    # 一つのノードのvalueを更新
    function update_at!(tree::BinaryIndexedTree{T}, i::Int, x::T) where T
        bits = tree.bits
        len = tree.len
        diff = x - bits[i].value
        bits[i].value = x
        while i <= len
            node = bits[i]
            node.interval_sum += diff
            i += node.lsb
        end
    end
    
    # 一つのノードのvalueをインクリメント
    function increase_at!(tree::BinaryIndexedTree{T}, i::Int, x::T) where T
        bits = tree.bits
        len = tree.len
        bits[i].value += x
        while i <= len
            node = bits[i]
            node.interval_sum += x
            i += node.lsb
        end
    end

    # a_1 ~ a_iまでの総和を計算
    function calc_sum(tree::BinaryIndexedTree{T}, i::Int) where T
        bits = tree.bits
        result = convert(T, 0)
        while i > 0
            node = bits[i]
            result += node.interval_sum
            i -= node.lsb
        end
        result
    end
end
