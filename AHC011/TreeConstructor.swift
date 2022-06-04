protocol TreeConstructor {
    init(board: Board)
    func construct() -> Board
}

final class TreeConstructorV1: TreeConstructor {
    private let initialBoard: Board
    private let resultBoard: Board
    private var tileCounts: [Int]
    private var allPositions: [Pos]
    private var seen: [[Bool]]
    
    init(board: Board) {
        self.initialBoard = board
        self.resultBoard = Board(n: initialBoard.n)
        self.tileCounts = initialBoard.countTiles()
        self.allPositions = []
        self.seen = [[Bool]](repeating: [Bool](repeating: false, count: resultBoard.n), count: resultBoard.n)
    }
    
    func construct() -> Board {
        // TODO: Select random
        let start = Pos(x: 3, y: 3)
        // TODO: Select first tile randomly
        resultBoard.place(at: start, tile: Tile(rawValue: 15)!, force: true)
        tileCounts[15] -= 1
        
        // just for first case
        seen[start.y][start.x] = true
        allPositions.append(start)
        
        let loopCount = 20
        // TODO: do several times
        // TODO: break tree (yakinamashi)
        // TODO: allow not connected branches at the end
        for _ in 0 ..< loopCount {
            extendBranch()
            trimBranch()
            addBranch()
        }
        
        var ptr = 1
        for i in 0 ..< resultBoard.n {
            for j in 0 ..< resultBoard.n {
                while ptr < 16 && tileCounts[ptr] == 0 {
                    ptr += 1
                }
                if resultBoard.tiles[i][j] == .none,
                   let tile = Tile(rawValue: ptr) {
                    resultBoard.place(at: Pos(x: j, y: i), tile: tile, force: true)
                    tileCounts[ptr] -= 1
                }
            }
        }
        
        return resultBoard
    }
    
    private func extendBranch() {
        for _ in 0 ..< 1000 {
            guard let pos = allPositions.first else {
                // No more positions
                break
            }
            
            for dir in Dir.all {
                let nextPos = pos + dir.pos
                guard nextPos.isValid(boardSize: resultBoard.n),
                      nextPos != Pos(x: resultBoard.n - 1, y: resultBoard.n - 1) else { continue }

                for rawValue in (1 ..< 16).shuffled() {
                    if let tile = Tile(rawValue: rawValue),
                       tile.isDir(dir: dir.rev) && tileCounts[rawValue] > 0,
                       resultBoard.isPlaceable(at: nextPos, tile: tile) {
//                        IO.log("extend: \(pos), \(nextPos), \(tile)", type: .debug)
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
    }
    
    private func addBranch() {
        // replace tile that will extend the tree if possible
        for i in 0 ..< resultBoard.n {
            for j in 0 ..< resultBoard.n {
                for dir in Dir.all.shuffled() {
                    let current = resultBoard.tiles[i][j]
                    guard !current.isDir(dir: dir),
                          current != .none else { continue }
                    let adjPos = Pos(x: j, y: i) + dir.pos
                    if adjPos.isValid(boardSize: resultBoard.n) &&
                        adjPos != Pos(x: resultBoard.n - 1, y: resultBoard.n - 1) &&
                        resultBoard.tiles[adjPos.y][adjPos.x] == .none {
                        guard let newTile = Tile(rawValue: current.rawValue ^ dir.rawValue) else {
                            IO.log("Unexpected rawValue \(current.rawValue ^ dir.rawValue)", type: .warn)
                            continue
                        }
                        if tileCounts[newTile.rawValue] > 0 {
//                            IO.log("add: \(current) -> \(newTile), \(Pos(x: j, y: i))", type: .debug)
                            tileCounts[newTile.rawValue] -= 1
                            tileCounts[current.rawValue] += 1
                            resultBoard.place(at: Pos(x: j, y: i), tile: newTile, force: true)
                            allPositions.append(Pos(x: j, y: i))
                        }
                    }
                }
            }
        }
    }
    
    private func trimBranch() {
        // find muda tile, and replace if possible
        for i in 0 ..< resultBoard.n {
            for j in 0 ..< resultBoard.n {
                for dir in Dir.all.shuffled() {
                    let current = resultBoard.tiles[i][j]
                    guard current.isDir(dir: dir) else { continue }
                    let adjPos = Pos(x: j, y: i) + dir.pos
                    if !adjPos.isValid(boardSize: resultBoard.n) ||
                        (resultBoard.tiles[adjPos.y][adjPos.x] != .none && !resultBoard.tiles[adjPos.y][adjPos.x].isDir(dir: dir.rev)) {
                        guard let newTile = Tile(rawValue: current.rawValue ^ dir.rawValue) else {
                            IO.log("Unexpected rawValue \(current.rawValue ^ dir.rawValue)", type: .warn)
                            continue
                        }
                        if tileCounts[newTile.rawValue] > 0 {
//                            IO.log("trim: \(current) -> \(newTile), \(Pos(x: j, y: i))", type: .debug)
                            tileCounts[newTile.rawValue] -= 1
                            tileCounts[current.rawValue] += 1
                            resultBoard.place(at: Pos(x: j, y: i), tile: newTile, force: true)
                        }
                    }
                }
            }
        }
    }
}
