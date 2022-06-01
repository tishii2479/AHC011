protocol MoveConstructor {
    init(startBoard: Board, endBoard: Board)
    func construct() -> [Move]
}

final class MoveConstructorV1: MoveConstructor {
    private let currentBoard: Board
    private let endBoard: Board
    
    init(startBoard: Board, endBoard: Board) {
        self.currentBoard = startBoard
        self.endBoard = endBoard
    }
    
    // 4  5 6 7
    // 3 10 9 8
    // 2 11
    // 1 12
    func construct() -> [Move] {
        var moves: [Move] = []
        moves += constructToMoveTile(from: Pos(x: 3, y: 3), to: Pos(x: 0, y: 0), excludePos: [])
        return moves
    }
    
    func constructToMoveTile(from startPos: Pos, to endPos: Pos, excludePos: [Pos]) -> [Move] {
        // pos where tile doesn't exist
        var currentPos = currentBoard.zeroTilePos
        var excludePos = excludePos
        var moves: [Move] = []
        
        let path = MoveUtil.convertDirToPath(
            startPos: startPos,
            dirs: MoveUtil.constructDirs(boardSize: endBoard.n, from: startPos, to: endPos, excludePos: excludePos)
        )
        
        for i in 0 ..< path.count - 1 {
            excludePos.append(path[i])
            moves += MoveUtil.constructDirs(boardSize: endBoard.n, from: currentPos, to: path[i + 1], excludePos: excludePos)
                .map { Move(dir: $0) }
            excludePos.removeLast()
            moves += MoveUtil.constructDirs(boardSize: endBoard.n, from: path[i + 1], to: path[i], excludePos: excludePos)
                .map { Move(dir: $0) }
            currentPos = path[i]
        }
        
        currentBoard.performMoves(moves: moves)
        return moves
    }
}
