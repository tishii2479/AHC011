protocol TreeConstructor {
    init(board: Board)
    func construct() -> Board
}

final class TreeConstructorV1: TreeConstructor {
    private let board: Board
    
    init(board: Board) {
        self.board = board
    }
    
    func construct() -> Board {
        var allTiles: [Tile] = board.allTiles
        
        // 1. Choose pos to start construct tree
        // 2. Select random tile type and place to pos
        // 3. Add candidate pos
        
        let start = Pos(x: 3, y: 3)
        // TODO: Use better method to shuffle
        allTiles.shuffle()
        
        for tile in allTiles {
            
        }
        
        return board
    }
}
