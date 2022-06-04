protocol MoveConstructor {
    init(startBoard: Board, endBoard: Board)
    func construct() -> [Move]
}

final class MoveConstructorV1: MoveConstructor {
    private let currentBoard: Board
    private let endBoard: Board
    private var moves: [Move]
    private var excludePos: Set<Pos>
    
    init(startBoard: Board, endBoard: Board) {
        self.currentBoard = startBoard
        self.endBoard = endBoard
        self.moves = []
        self.excludePos = Set<Pos>()
    }
    
    func construct() -> [Move] {
        for d in 0 ..< currentBoard.n - 2 {
            if d % 2 == 0 {
                // 6  7  8  9 10 11
                // 5 16 15 14 13 12
                // 4 17 24 25 26 27
                // 3 18 23 30 29 28
                // 2 19 22 31
                // 1 20 21 32

                // 1, 2, 3, 4
                for y in (d + 2 ..< currentBoard.n).reversed() {
                    let x = d
                    findTileAndMove(tile: endBoard.tiles[y][x], to: Pos(x: x, y: y))
                    excludePos.insert(Pos(x: x, y: y))
                }
                
                // 5, 6
                findTileAndMove(tile: endBoard.tiles[d + 1][d], to: Pos(x: d, y: d))
                excludePos.insert(Pos(x: d, y: d))

                if currentBoard.tiles[d + 1][d] == endBoard.tiles[d][d] {
                    // is stuck
                    // b
                    // a
                    // c x
                    addMoves(
                        moves: Util.constructDirs(boardSize: currentBoard.n, from: currentBoard.zeroTilePos, to: Pos(x: d, y: d + 1), excludePos: excludePos)
                            .map { Move(dir: $0) }
                    )
                }
                if currentBoard.zeroTilePos == Pos(x: d, y: d + 1) && currentBoard.tiles[d + 1][d + 1] == endBoard.tiles[d][d] {
                    // is blocked
                    // b
                    // xa
                    // c
                    addMoves(
                        moves: [Dir.down, Dir.right, Dir.right, Dir.up, Dir.up, Dir.left, Dir.down, Dir.down, Dir.left, Dir.up, Dir.up, Dir.right]
                            .map { Move(dir: $0) }
                    )
                } else {
                    findTileAndMove(tile: endBoard.tiles[d][d], to: Pos(x: d + 1, y: d))
                    excludePos.insert(Pos(x: d + 1, y: d))
                    
                    addMoves(
                        moves: Util.constructDirs(boardSize: currentBoard.n, from: currentBoard.zeroTilePos, to: Pos(x: d, y: d + 1), excludePos: excludePos)
                            .map { Move(dir: $0) }
                    )
                    addMoves(moves: [Dir.up, Dir.right].map { Move(dir: $0) })
                }
                
                excludePos.insert(Pos(x: d, y: d + 1))
                excludePos.remove(Pos(x: d + 1, y: d))
                
                // 7, 8, 9
                for x in 1 + d ..< currentBoard.n - 2 {
                    let y = d
                    findTileAndMove(tile: endBoard.tiles[y][x], to: Pos(x: x, y: y))
                    excludePos.insert(Pos(x: x, y: y))
                }
                
                // 10, 11
                findTileAndMove(tile: endBoard.tiles[d][currentBoard.n - 2], to: Pos(x: currentBoard.n - 1, y: d))
                excludePos.insert(Pos(x: currentBoard.n - 1, y: d))

                if currentBoard.tiles[d][currentBoard.n - 2] == endBoard.tiles[d][currentBoard.n - 1] {
                    // is stuck
                    // cab
                    // x
                    //
                    // to
                    //
                    // cxb
                    //  a
                    addMoves(
                        moves: Util.constructDirs(boardSize: currentBoard.n, from: currentBoard.zeroTilePos, to: Pos(x: currentBoard.n - 2, y: d), excludePos: excludePos)
                            .map { Move(dir: $0) }
                    )
                }
                if currentBoard.zeroTilePos == Pos(x: currentBoard.n - 2, y: d) && currentBoard.tiles[d + 1][currentBoard.n - 2] == endBoard.tiles[d][currentBoard.n - 1] {
                    // is blocked
                    // cxb
                    // da
                    // e
                    addMoves(
                        moves: [Dir.left, Dir.down, Dir.down, Dir.right, Dir.right, Dir.up, Dir.left, Dir.down, Dir.left, Dir.up, Dir.up, Dir.right, Dir.right, Dir.down]
                            .map { Move(dir: $0) }
                    )
                } else {
                    findTileAndMove(tile: endBoard.tiles[d][currentBoard.n - 1], to: Pos(x: currentBoard.n - 1, y: d + 1))
                    excludePos.insert(Pos(x: currentBoard.n - 1, y: d + 1))
                    
                    addMoves(
                        moves: Util.constructDirs(boardSize: currentBoard.n, from: currentBoard.zeroTilePos, to: Pos(x: currentBoard.n - 2, y: d), excludePos: excludePos)
                            .map { Move(dir: $0) }
                    )
                    addMoves(moves: [Dir.right, Dir.down].map { Move(dir: $0) })
                }
                
                excludePos.insert(Pos(x: currentBoard.n - 2, y: d))
                excludePos.remove(Pos(x: currentBoard.n - 1, y: d + 1))
            } else {
                // 6  7  8  9 10 11
                // 5 16 15 14 13 12
                // 4 17 24 25 26 27
                // 3 18 23 30 29 28
                // 2 19 22 31
                // 1 20 21 32
                
                // 12, 13, 14
                for x in (d + 2 ..< currentBoard.n).reversed() {
                    let y = d
                    findTileAndMove(tile: endBoard.tiles[y][x], to: Pos(x: x, y: y))
                    excludePos.insert(Pos(x: x, y: y))
                }
                
                // 15, 16
                findTileAndMove(tile: endBoard.tiles[d][d + 1], to: Pos(x: d, y: d))
                excludePos.insert(Pos(x: d, y: d))
                
                if currentBoard.tiles[d][d + 1] == endBoard.tiles[d][d] {
                    // is stuck
                    // bac
                    // x
                    addMoves(
                        moves: Util.constructDirs(boardSize: currentBoard.n, from: currentBoard.zeroTilePos, to: Pos(x: d + 1, y: d), excludePos: excludePos)
                            .map { Move(dir: $0) }
                    )
                }
                if currentBoard.zeroTilePos == Pos(x: d + 1, y: d) && currentBoard.tiles[d + 1][d + 1] == endBoard.tiles[d][d] {
                    // is blocked
                    // bxc
                    //  a
                    addMoves(
                        moves: [Dir.right, Dir.down, Dir.down, Dir.left, Dir.left, Dir.up, Dir.right, Dir.right, Dir.up, Dir.left, Dir.left, Dir.down]
                            .map { Move(dir: $0) }
                    )
                } else {
                    findTileAndMove(tile: endBoard.tiles[d][d], to: Pos(x: d, y: d + 1))
                    excludePos.insert(Pos(x: d, y: d + 1))
                    
                    addMoves(
                        moves: Util.constructDirs(boardSize: currentBoard.n, from: currentBoard.zeroTilePos, to: Pos(x: d + 1, y: d), excludePos: excludePos)
                            .map { Move(dir: $0) }
                    )
                    addMoves(moves: [Dir.left, Dir.down].map { Move(dir: $0) })
                }
                
                excludePos.insert(Pos(x: d + 1, y: d))
                excludePos.remove(Pos(x: d, y: d + 1))
                
                // 17, 18
                for y in d + 1 ..< currentBoard.n - 2 {
                    let x = d
                    findTileAndMove(tile: endBoard.tiles[y][x], to: Pos(x: x, y: y))
                    excludePos.insert(Pos(x: x, y: y))
                }
                
                // 19, 20
                findTileAndMove(tile: endBoard.tiles[currentBoard.n - 2][d], to: Pos(x: d, y: currentBoard.n - 1))
                excludePos.insert(Pos(x: d, y: currentBoard.n - 1))
                if currentBoard.tiles[currentBoard.n - 2][d] == endBoard.tiles[currentBoard.n - 1][d] {
                    // is stuck
                    // c
                    // ax
                    // b
                    addMoves(
                        moves: Util.constructDirs(boardSize: currentBoard.n, from: currentBoard.zeroTilePos, to: Pos(x: d, y: currentBoard.n - 2), excludePos: excludePos)
                            .map { Move(dir: $0) }
                    )
                }
                if currentBoard.zeroTilePos == Pos(x: d, y: currentBoard.n - 2) && currentBoard.tiles[currentBoard.n - 2][d + 1] == endBoard.tiles[currentBoard.n - 1][d] {
                    // is blocked
                    // cde
                    // xa
                    // b
                    //
                    addMoves(
                        moves: [Dir.up, Dir.right, Dir.right, Dir.down, Dir.down, Dir.left, Dir.up, Dir.right, Dir.up, Dir.left, Dir.left, Dir.down, Dir.down, Dir.right]
                            .map { Move(dir: $0) }
                    )
                } else {
                    findTileAndMove(tile: endBoard.tiles[currentBoard.n - 1][d], to: Pos(x: d + 1, y: currentBoard.n - 1))
                    excludePos.insert(Pos(x: d + 1, y: currentBoard.n - 1))
                    
                    addMoves(
                        moves: Util.constructDirs(boardSize: currentBoard.n, from: currentBoard.zeroTilePos, to: Pos(x: d, y: currentBoard.n - 2), excludePos: excludePos)
                            .map { Move(dir: $0) }
                    )
                    addMoves(moves: [Dir.down, Dir.right].map { Move(dir: $0) })
                }
                
                excludePos.insert(Pos(x: d, y: currentBoard.n - 2))
                excludePos.remove(Pos(x: d + 1, y: currentBoard.n - 1))
            }
        }
        return moves
    }
    
    private func addMoves(moves add: [Move]) {
        if !currentBoard.performMoves(moves: add) {
            currentBoard.log()
            endBoard.log()
            fatalError()
        }
        moves += add
    }
    
    private func findTileAndMove(tile: Tile, to endPos: Pos) {
        guard tile != .none else { return }
        guard let startPos = currentBoard.findTile(tile: tile, fromPos: currentBoard.zeroTilePos, excludePos: excludePos) else {
            IO.log("Could not find tile: \(tile)", type: .warn)
            return
        }
        constructToMoveTile(from: startPos, to: endPos)
    }
    
    private func constructToMoveTile(from startPos: Pos, to endPos: Pos) {
        // pos where tile doesn't exist
        var currentPos = currentBoard.zeroTilePos
        
        let path = Util.convertDirToPath(
            startPos: startPos,
            dirs: Util.constructDirs(boardSize: endBoard.n, from: startPos, to: endPos, excludePos: excludePos)
        )
        
//        IO.log("turn: \(moves.count), startPos: \(startPos), endPos: \(endPos)")
        
        for i in 0 ..< path.count - 1 {
            addMoves(
                moves: Util.constructDirs(
                    boardSize: endBoard.n,
                    from: currentPos, to: path[i + 1],
                    excludePos: excludePos.union([path[i]])
                )
                .map { Move(dir: $0) }
            )
            addMoves(
                moves: Util.constructDirs(boardSize: endBoard.n, from: path[i + 1], to: path[i], excludePos: excludePos)
                    .map { Move(dir: $0) }
            )
            currentPos = path[i]
        }
    }
}
