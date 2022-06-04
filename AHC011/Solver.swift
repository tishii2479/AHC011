import Foundation

protocol Solver {
    init(board: Board)
    func solve() -> [Move]
}

final class SolverV1<
    T: TreeConstructor,
    M: MoveConstructor
>: Solver {
    private let initialBoard: Board

    init(board: Board) {
        self.initialBoard = board
    }
    
    func solve() -> [Move] {
        IO.log("Start solve")
        var bestTreeSize: Int = 0
        var bestMove: [Move] = []
        // TODO: loop, calc score, choose best endboard
        while Date() < runLimitDate {
            let board = initialBoard.copy()
            let treeConstructor = T(board: board)
            let endBoard = treeConstructor.construct()
            let moveConstructor = M(startBoard: board, endBoard: endBoard)
            let move = moveConstructor.construct()
            let treeSize = Util.calcTreeSize(board: board)
            if treeSize > bestTreeSize && move.count <= board.n * board.n * board.n * 2 {
                bestMove = move
                bestTreeSize = treeSize
                IO.log(bestTreeSize, type: .info)
            }
        }
        return bestMove
    }
}
