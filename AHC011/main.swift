func main() {
    let arr: [Int] = IO.readIntArray()
    let n: Int = arr[0], _ = arr[1]
    var rawBoard = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
    for i in 0 ..< n {
        let str: String = IO.readString()
        for (j, e) in str.enumerated() {
            rawBoard[i][j] = Int(String(e), radix: 16)!
        }
    }
    let board = Board(n: n, board: rawBoard)
    let solver: Solver = SolverV1(board: board)
    solver.solve()
    solver.log()
}

main()
