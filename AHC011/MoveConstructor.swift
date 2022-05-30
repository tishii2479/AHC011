protocol MoveConstructor {
    init(startBoard: Board, endBoard: Board)
    func construct() -> [Dir]
}

final class MoveConstructorV1: MoveConstructor {
    private let startBoard: Board
    private let endBoard: Board
    
    init(startBoard: Board, endBoard: Board) {
        self.startBoard = startBoard
        self.endBoard = endBoard
    }
    
    func construct() -> [Dir] {
        return []
    }
}
