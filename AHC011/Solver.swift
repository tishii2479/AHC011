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
        var loopCount = 0
//        while bestMove.count == 0 {
        while Date() < runLimitDate {
//        while bestTreeSize < initialBoard.n * initialBoard.n - 1 {
            loopCount += 1
            let board = initialBoard.copy()
            let treeConstructor = T(board: board)
            let endBoard = treeConstructor.construct()
            let expectedTreeSize = Util.calcTreeSize(board: endBoard)
            
            if expectedTreeSize <= bestTreeSize { continue }
            
            let moveConstructor = M(startBoard: board, endBoard: endBoard)
            let move = moveConstructor.construct()
            let actualTreeSize = Util.calcTreeSize(board: board)
            
            if expectedTreeSize != actualTreeSize {
                // ab   ac
                // cx   bx
                IO.log("Tree size is not correct: \(expectedTreeSize), \(actualTreeSize)", type: .warn)
            }
            if actualTreeSize > bestTreeSize && move.count <= board.n * board.n * board.n * 2 {
                bestMove = move
                bestTreeSize = actualTreeSize
                IO.log("best tree size is: \(bestTreeSize), move count: \(bestMove.count)", type: .info)
            }
            // is largest tree
            if actualTreeSize == board.n * board.n - 1 {
                for i in 0 ..< 1000 {
                    guard Date() < runLimitDate else {
                        IO.log("ended at index: \(i)")
                        break
                    }
                    let board = initialBoard.copy()
                    let moveConstructor = M(startBoard: board, endBoard: endBoard)
                    let move = moveConstructor.construct()
                    let actualTreeSize = Util.calcTreeSize(board: board)
                    if actualTreeSize == board.n * board.n - 1 && move.count <= board.n * board.n * board.n * 2 &&
                        (bestMove.count == 0 || move.count < bestMove.count) {
                        bestMove = move
                        bestTreeSize = actualTreeSize
                        IO.log("best tree size is: \(bestTreeSize), move count: \(bestMove.count)", type: .info)
                    }
                }
            }
        }
        IO.log("Loop count: \(loopCount)")
        return bestMove
    }
}
