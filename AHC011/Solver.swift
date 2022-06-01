protocol Solver {
    init(board: Board)
    func solve() -> [Move]
}

final class SolverV1<
    T: TreeConstructor,
    M: MoveConstructor
>: Solver {
    private let board: Board

    init(board: Board) {
        self.board = board
    }
    
    func solve() -> [Move] {
        IO.log("Start solve")
        let treeConstructor = T(board: board)
        let endBoard = treeConstructor.construct()
        let moveConstructor = M(startBoard: board, endBoard: endBoard)
        let move = moveConstructor.construct()
        
        return move
    }
}
