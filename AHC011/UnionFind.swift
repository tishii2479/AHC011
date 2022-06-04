class UnionFind {
    private let n: Int
    private var par: [Int]
    
    init(n: Int) {
        self.n = n
        self.par = [Int](repeating: -1, count: n)
    }

    @discardableResult
    func merge(_ a: Int, _ b: Int) -> Bool {
        var a = root(of: a), b = root(of: b)
        guard a != b else { return false }
        if par[a] > par[b] {
            swap(&a, &b)
        }
        par[a] += par[b]
        par[b] = a
        return true
    }
    
    func same(_ a: Int, _ b: Int) -> Bool {
        root(of: a) == root(of: b)
    }
    
    func root(of a: Int) -> Int {
        if par[a] < 0 {
            return a
        }
        par[a] = root(of: par[a])
        return par[a]
    }
    
    func size(of a: Int) -> Int {
        -par[root(of: a)]
    }
}

class GridUnionFind: UnionFind {
    private let row: Int
    private let col: Int

    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        super.init(n: row * col)
    }

    @discardableResult
    func merge(_ a: Pos, _ b: Pos) -> Bool {
        super.merge(toIndex(pos: a), toIndex(pos: b))
    }
    
    func same(_ a: Pos, _ b: Pos) -> Bool {
        super.same(toIndex(pos: a), toIndex(pos: b))
    }
    
    func root(of a: Pos) -> Pos {
        toPos(index: super.root(of: toIndex(pos: a)))
    }
    
    func size(of a: Pos) -> Int {
        super.size(of: toIndex(pos: a))
    }
    
    private func toIndex(pos: Pos) -> Int {
        pos.y * col + pos.x
    }
    
    private func toPos(index: Int) -> Pos {
        Pos(x: index % col, y: index / col)
    }
}
