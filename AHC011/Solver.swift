protocol Solver {
    init(board: Board)
    func solve()
    func log()
}

final class SolverV1: Solver {
    let board: Board
    init(board: Board) {
        self.board = board
    }
    
    func solve() {
        IO.log("Start solve")
    }
    
    func log() {
        board.dump()
    }
}
