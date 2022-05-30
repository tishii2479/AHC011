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
        var allTiles: [Tile] = initialBoard.allTiles
        allTiles.shuffle()
        var used: [Bool] = [Bool](repeating: false, count: allTiles.count)
        let resultBoard = Board(n: initialBoard.n)
        
        let start = Pos(x: 3, y: 3)
        // O(n)
        resultBoard.place(at: start, tile: allTiles.removeFirst(), force: true)
        
        var allPositions: [Pos] = [start]
        var seen: [[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: resultBoard.n), count: resultBoard.n)
        
        for _ in 0 ..< 1000 {
            guard let pos = allPositions.first else {
                IO.log("No more positions, pos count: \(allPositions.count)", type: .warn)
                break
            }

            // just for first case
            seen[pos.y][pos.x] = true
            
            for dir in Dir.all {
                let nextPos = pos + dir.pos
                guard nextPos.isValid(boardSize: resultBoard.n) else { continue }
                for (i, tile) in allTiles.enumerated() {
                    guard !used[i] else { continue }
                    // don't allow to end create tree
                    if tile.rawValue.nonzeroBitCount == 1 && allPositions.count == 1 {
                        continue
                    }
                    if resultBoard.isPlaceable(at: nextPos, tile: tile) {
                        resultBoard.place(at: nextPos, tile: tile, force: true)
                        if !seen[nextPos.y][nextPos.x] {
                            // prevent appending newPos again
                            seen[nextPos.y][nextPos.x] = true
                            allPositions.append(nextPos)
                            used[i] = true
                        }
                        break
                    }
                }
            }

            // O(n)
            allPositions.removeFirst()
            allTiles.removeFirst()
        }
        
        resultBoard.log()
        return resultBoard
    }
}
