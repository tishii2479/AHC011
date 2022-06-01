enum MoveUtil {
    static func constructDirs(boardSize: Int, from startPos: Pos, to endPos: Pos, excludePos: [Pos]) -> [Dir] {
        let inf = 123456
        var dist: [[Int]] = [[Int]](repeating: [Int](repeating: inf, count: boardSize), count: boardSize)
        let isExcluded: [[Bool]] = {
            var res: [[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: boardSize), count: boardSize)
            for pos in excludePos {
                res[pos.y][pos.x] = true
            }
            return res
        }()

        let queue = Queue<Pos>()
        dist[startPos.y][startPos.x] = 0
        queue.push(startPos)
        
        while queue.count > 0 {
            guard let pos = queue.pop() else { break }
            for dir in Dir.all {
                let nextPos = pos + dir.pos
                guard nextPos.isValid(boardSize: boardSize),
                      !isExcluded[nextPos.y][nextPos.x] else { continue }
                
                if dist[pos.y][pos.x] + 1 < dist[nextPos.y][nextPos.x] {
                    dist[nextPos.y][nextPos.x] = dist[pos.y][pos.x] + 1
                    queue.push(nextPos)
                }
            }
            // branch cutting
            if dist[endPos.y][endPos.x] < inf { break }
        }
        
        guard dist[endPos.y][endPos.x] < inf else {
            IO.log("\(endPos) is not reachable from \(startPos), \(excludePos), \(dist), \(excludePos)")
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
