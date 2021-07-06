# ヒープ
module MyHeap
    export Heap, add!, remove!, __peek

    struct Heap{T}
        cont::Array{T, 1}　#ヒープ化された配列を持つ
        lt::Function #比較に関する関数(デフォルトはisless)
    end

    # コンストラクタ
    function Heap{T}(; lt=isless) where T
        cont = Array{T, 1}()
        Heap(cont, lt)
    end

    # 要素を一つ追加
    function add!(heap::Heap{T}, x::T) where T
        push!(heap.cont, x)
        a = heap.cont
        len = length(a)
        i = len
        j = i ÷ 2

        while j > 0
            if heap.lt(a[i], a[j])
                a[i], a[j] = a[j], a[i]
                i, j = j, j ÷ 2
            else
                break
            end
        end
    end

    # 要素を一つ取り出す
    function remove!(heap::Heap)
        a = heap.cont
        if iszero(length(a)) return end
        result = popfirst!(a)
        
        len = length(a)
        if iszero(len) return result end
        temp = pop!(a)
        pushfirst!(a, temp)

        # 要素を取り出した後のヒープ再構築
        i = 1
        left, right = 2, 3
        while left <= len
            if right > len
                if !heap.lt(a[i], a[left])
                    a[i], a[left] = a[left], a[i]
                    i = 2left
                    left, right = 2i, 2i + 1
                else
                    break
                end
            else
                if heap.lt(a[left], a[right])
                    if !heap.lt(a[i], a[left])
                        a[i], a[left] = a[left], a[i]
                        i *= 2
                        left, right = 2i, 2i + 1
                    else
                        break
                    end
                else
                    if !heap.lt(a[i], a[right])
                        a[i], a[right] = a[right], a[i]
                        i = 2i + 1
                        left, right = 2i, 2i + 1
                    else
                        break
                    end
                end
            end
        end
        result
    end

    # 次に取り出す要素を確認
    function __peek(heap::Heap{T}) where T
        if !isempty(heap.cont)
            return heap.cont[1]
        end
    end
end

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
            node = bits[i]
            lsb = node.lsb
            j = 0
            while j < lsb
                node.interval_sum += bits[i - j].value
                j += 1
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

# TODO:
    # BITの区間和ver と 区間最小値verを、モジュールを分けて実装したい。
# -----commingsooon-------

# セグメントツリー
