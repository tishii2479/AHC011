protocol Solver {
    init(board: Board)
    func solve() -> [Dir]
}

final class SolverV1<
    T: TreeConstructor,
    M: MoveConstructor
>: Solver {
    private let board: Board

    init(board: Board) {
        self.board = board
    }
    
    func solve() -> [Dir] {
        IO.log("Start solve")
        let treeConstructor = T(board: board)
        let endBoard = treeConstructor.construct()
        let moveConstructor = M(startBoard: board, endBoard: endBoard)
        let move = moveConstructor.construct()
        
        return move
    }
}
