class Board {
    let n: Int
    var board: [[Int]]
    
    init(
        n: Int,
        board: [[Int]]
    ) {
        self.n = n
        self.board = board
    }
    
    func dump() {
        IO.log(board)
    }
}
