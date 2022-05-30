protocol TreeConstructor {
    init(board: Board)
    func construct() -> Board
}

final class TreeConstructorV1: TreeConstructor {
    private let initialBoard: Board
    
    init(board: Board) {
        self.initialBoard = board
    }
    
    func construct() -> Board {
        var tileCounts: [Int] = initialBoard.countTiles()
        let resultBoard = Board(n: initialBoard.n)
        
        let start = Pos(x: 3, y: 3)
        resultBoard.place(at: start, tile: Tile(rawValue: 15)!, force: true)
        tileCounts[15] -= 1
        
        var allPositions: [Pos] = [start]
        var seen: [[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: resultBoard.n), count: resultBoard.n)
        
        // just for first case
        seen[start.y][start.x] = true
        
        for _ in 0 ..< 1000 {
            guard let pos = allPositions.first else {
                IO.log("No more positions, pos count: \(allPositions.count)", type: .warn)
                break
            }
            
            for dir in Dir.all {
                let nextPos = pos + dir.pos
                guard nextPos.isValid(boardSize: resultBoard.n) else { continue }

                for _ in 0 ..< 100 {
                    let rawValue = Int.random(in: 1..<16)
                    if let tile = Tile(rawValue: rawValue),
                       tile.isDir(dir: dir.rev) && tileCounts[rawValue] > 0,
                       resultBoard.isPlaceable(at: nextPos, tile: tile) {
                        resultBoard.place(at: nextPos, tile: tile, force: true)
                        tileCounts[rawValue] -= 1
                        if !seen[nextPos.y][nextPos.x] {
                            // prevent appending newPos again
                            seen[nextPos.y][nextPos.x] = true
                            allPositions.append(nextPos)
                        }
                        break
                    }
                }
            }

            // O(n)
            allPositions.removeFirst()
        }
        
        // find muda tile, and replace if possible
        
        // replace tile that will extend the tree
        
        resultBoard.log()
        IO.log(tileCounts)
        return resultBoard
    }
}
