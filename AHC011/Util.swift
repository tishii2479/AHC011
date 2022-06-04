enum Util {
    static func constructDirs(boardSize: Int, from startPos: Pos, to endPos: Pos, excludePos: Set<Pos>) -> [Dir] {
        let inf = 123456
        var dist: [[Int]] = [[Int]](repeating: [Int](repeating: inf, count: boardSize), count: boardSize)
        let queue = Queue<Pos>()
        dist[startPos.y][startPos.x] = 0
        queue.push(startPos)
        
        while queue.count > 0 {
            guard let pos = queue.pop() else { break }
            for dir in Dir.all {
                let nextPos = pos + dir.pos
                guard nextPos.isValid(boardSize: boardSize),
                      !excludePos.contains(nextPos) else { continue }
                
                if dist[pos.y][pos.x] + 1 < dist[nextPos.y][nextPos.x] {
                    dist[nextPos.y][nextPos.x] = dist[pos.y][pos.x] + 1
                    queue.push(nextPos)
                }
            }
            // branch cutting
            if dist[endPos.y][endPos.x] < inf { break }
        }
        
        guard dist[endPos.y][endPos.x] < inf else {
            IO.log("\(endPos) is not reachable from \(startPos)")
            for i in 0 ..< boardSize {
                for j in 0 ..< boardSize {
                    if excludePos.contains(Pos(x: j, y: i)) {
                        IO.log("#", terminator: "", type: .none)
                    }
                    else {
                        IO.log(".", terminator: "", type: .none)
                    }
                }
                IO.log("", type: .none)
            }
            
            for i in 0 ..< boardSize {
                for j in 0 ..< boardSize {
                    IO.log(dist[i][j], terminator: " ", type: .none)
                }
                IO.log("", type: .none)
            }
            return []
        }
        
        // reverse
        var dirs: [Dir] = []

        var currentPos = endPos
        while currentPos != startPos {
            var checkOk = false
            for dir in Dir.all.shuffled() {
                let nextPos = currentPos + dir.pos
                guard nextPos.isValid(boardSize: boardSize) else { continue }
                
                if dist[currentPos.y][currentPos.x] == dist[nextPos.y][nextPos.x] + 1 {
                    currentPos = nextPos
                    checkOk = true
                    dirs.append(dir.rev)
                    break
                }
            }
            
            if !checkOk {
                IO.log("Failed to reverse path from \(endPos) to \(startPos)", type: .warn)
                return []
            }
        }

        return dirs.reversed()
    }
    
    static func convertDirToPath(startPos: Pos, dirs: [Dir]) -> [Pos] {
        var path: [Pos] = [startPos]
        var currentPos = startPos
        for dir in dirs {
            currentPos += dir.pos
            path.append(currentPos)
        }
        return path
    }
    
    static func calcTreeSize(board: Board) -> Int {
        let uf = GridUnionFind(row: board.n, col: board.n)
        var isLoop = Set<Pos>()
        for i in 0 ..< board.n {
            for j in 0 ..< board.n - 1 {
                if board.tiles[i][j].isDir(dir: .right) && board.tiles[i][j + 1].isDir(dir: .left) {
                    let l = Pos(x: j, y: i), r = Pos(x: j + 1, y: i)
                    if uf.same(l, r) {
                        isLoop.insert(l)
                    }
                    uf.merge(l, r)
                }
            }
        }
        
        for j in 0 ..< board.n {
            for i in 0 ..< board.n - 1 {
                if board.tiles[i][j].isDir(dir: .down) && board.tiles[i + 1][j].isDir(dir: .up) {
                    let l = Pos(x: j, y: i), r = Pos(x: j, y: i + 1)
                    if uf.same(l, r) {
                        isLoop.insert(l)
                    }
                    uf.merge(l, r)
                }
            }
        }
        
        var isLoopRoot = Set<Pos>()
        for i in 0 ..< board.n {
            for j in 0 ..< board.n {
                let pos = Pos(x: j, y: i)
                if isLoop.contains(pos) {
                    isLoopRoot.insert(uf.root(of: pos))
                }
            }
        }
        
        var mx = 0
        for i in 0 ..< board.n {
            for j in 0 ..< board.n {
                let pos = Pos(x: j, y: i)
                if uf.root(of: pos) == pos && !isLoopRoot.contains(pos) {
                    mx = max(uf.size(of: pos), mx)
                }
            }
        }
        return mx
    }
}
