func main() {
    let board = readInput()
    let solver: Solver = SolverV1<TreeConstructorV1, MoveConstructorV1>(board: board)
    let moves = solver.solve()
    IO.log(moves.map { $0.str }.joined())
    IO.output(moves.map { $0.str }.joined())
}

private func readInput() -> Board {
    let arr: [Int] = IO.readIntArray()
    let n: Int = arr[0], _ = arr[1]
    var tiles = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
    for i in 0 ..< n {
        let str: String = IO.readString()
        for (j, e) in str.enumerated() {
            tiles[i][j] = Int(String(e), radix: 16)!
        }
    }
    return Board(tiles: tiles)
}

main()
