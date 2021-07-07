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
