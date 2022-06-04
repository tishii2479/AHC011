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
            // TODO: Add random?
            for dir in Dir.all {
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
}
