import Foundation
protocol TreeConstructor {
    init(board: Board)
    func construct() -> Board
}

final class TreeConstructorV1: TreeConstructor {
    private let initialBoard: Board
    private var resultBoard: Board
    private var tileCounts: [Int]
    private var allPositions: Queue<Pos>
    private var seen: [[Bool]]
    
    init(board: Board) {
        self.initialBoard = board
        self.resultBoard = Board(n: initialBoard.n)
        self.tileCounts = initialBoard.countTiles()
        self.allPositions = Queue<Pos>()
        self.seen = [[Bool]](repeating: [Bool](repeating: false, count: resultBoard.n), count: resultBoard.n)
    }
    
    func construct() -> Board {
        let start = Pos(x: Int.random(in: 2 ..< initialBoard.n - 2), y: Int.random(in: 2 ..< initialBoard.n - 2))
        var startTile: Tile? = nil
        repeat {
            startTile = Tile(rawValue: [7, 11, 13, 14, 15].randomElement()!)
        } while startTile == nil || tileCounts[startTile!.rawValue] == 0
        resultBoard.place(at: start, tile: startTile!, force: true)
        tileCounts[startTile!.rawValue] -= 1
        
        // just for first case
        seen[start.y][start.x] = true
        allPositions.push(start)
        
        for _ in 0 ..< 3 {
            extendBranch()
            trimBranch()
            addBranch()
        }
        
        for t in 0 ..< 90 {
            let currentScore = breakBranch(temperature: Double(t) / 90)
            if currentScore < resultBoard.n * resultBoard.n - resultBoard.n {
                break
            }
        }
        
        // aita tokorowo umeru, migisita ha umenai
        var ptr = 1
        for i in 0 ..< resultBoard.n {
            for j in 0 ..< resultBoard.n {
                while ptr < 16 && tileCounts[ptr] == 0 {
                    ptr += 1
                }
                if ptr < 16 && tileCounts[ptr] > 0,
                   resultBoard.tiles[i][j] == .none,
                   let tile = Tile(rawValue: ptr) {
                    resultBoard.place(at: Pos(x: j, y: i), tile: tile, force: true)
                    tileCounts[ptr] -= 1
                }
            }
        }

        if resultBoard.tiles[resultBoard.n - 1][resultBoard.n - 1] != .none {
            IO.log("migisita is not none", type: .warn)
            IO.log(tileCounts)
            resultBoard.log()
        }
        
        return resultBoard
    }
    
    private func breakBranch(temperature: Double) -> Int {
        let _startPos: Pos? = {
            for _ in 0 ..< 10 {
                let pos = Pos(x: Int.random(in: 0 ..< resultBoard.n), y: Int.random(in: 0 ..< resultBoard.n))
                if resultBoard.tiles[pos.y][pos.x].rawValue.nonzeroBitCount <= 1 ||
                    pos == Pos(x: resultBoard.n - 1, y: resultBoard.n - 1) {
                    continue
                }
                return pos
            }
            return nil
        }()
        guard let startPos = _startPos else {
            return 123456
        }

        // break one direction, and reset sono saki no tiles
        for dir in Dir.all.shuffled() {
            guard resultBoard.tiles[startPos.y][startPos.x].isDir(dir: dir) else { continue }
            
            // TODO: break with probability
            var removed = Set<Pos>()
            let queue = Queue<Pos>()
            queue.push(startPos + dir.pos)
            
            while queue.count > 0 {
                guard let pos = queue.pop() else { break }
                for dir in Dir.all {
                    guard resultBoard.tiles[pos.y][pos.x].isDir(dir: dir) else { continue }
                    let nextPos = pos + dir.pos
                    if nextPos.isValid(boardSize: resultBoard.n) &&
                        resultBoard.tiles[nextPos.y][nextPos.x].isDir(dir: dir.rev) &&
                        nextPos != startPos &&
                        !removed.contains(nextPos) {
                        removed.insert(nextPos)
                        queue.push(nextPos)
                    }
                }
            }
            
            // if remove tiles are too big, skip
            if removed.count > resultBoard.n * 2 {
                continue
            }

            let tempTileCounts = tileCounts
            let tempSeen = seen
            
            for removePos in removed {
                tileCounts[resultBoard.tiles[removePos.y][removePos.x].rawValue] += 1
                seen[removePos.y][removePos.x] = false
            }
            
            guard let newTileForStartPos = Tile(rawValue: resultBoard.tiles[startPos.y][startPos.x].rawValue - dir.rawValue) else {
                IO.log("new tile for start pos does not exist, rawValue: \(resultBoard.tiles[startPos.y][startPos.x].rawValue - dir.rawValue)", type: .warn)
                continue
            }
            
            // if not replacable, skip
            guard tileCounts[newTileForStartPos.rawValue] > 0 else {
                tileCounts = tempTileCounts
                seen = tempSeen
                continue
            }
            
            let tempResultBoard = resultBoard.copy()

            tileCounts[resultBoard.tiles[startPos.y][startPos.x].rawValue] += 1
            resultBoard.place(at: startPos, tile: newTileForStartPos, force: true)
            tileCounts[newTileForStartPos.rawValue] -= 1

            for removePos in removed {
                resultBoard.place(at: removePos, tile: .none, force: true)
            }
            
            for _ in 0 ..< 3 {
                extendBranch()
                trimBranch()
                addBranch()
            }
            
            let currentScore = Util.calcTreeSize(board: tempResultBoard)
            let newScore = Util.calcTreeSize(board: resultBoard)
            
            // score improved
            // TODO: Add probability
            if newScore > currentScore {
//            if newScore > currentScore || Double(currentScore - newScore) < Double.random(in: 0 ... Double(max(0, 0.8 - temperature) * 5)) {
//                IO.log("\(temperature): newScore: \(newScore), currentScore: \(currentScore)")
            } else {
                tileCounts = tempTileCounts
                seen = tempSeen
                resultBoard = tempResultBoard
            }
            
            return max(currentScore, newScore)
        }
        return 123456
    }
    
    private func extendBranch() {
        for _ in 0 ..< 1000 {
            guard let pos = allPositions.pop() else {
                // No more positions
                break
            }
            
            for dir in Dir.all.shuffled() {
                let nextPos = pos + dir.pos
                guard nextPos.isValid(boardSize: resultBoard.n),
                      nextPos != Pos(x: resultBoard.n - 1, y: resultBoard.n - 1) else { continue }

                for rawValue in (1 ..< 16).shuffled() {
                    if let tile = Tile(rawValue: rawValue),
                       tile.isDir(dir: dir.rev) && tileCounts[rawValue] > 0,
                       resultBoard.isPlaceable(at: nextPos, tile: tile) {
//                        IO.log("extend: \(pos), \(nextPos), \(tile)", type: .debug)
                        resultBoard.place(at: nextPos, tile: tile, force: true)
                        tileCounts[rawValue] -= 1
                        if !seen[nextPos.y][nextPos.x] {
                            // prevent appending newPos again
                            seen[nextPos.y][nextPos.x] = true
                            allPositions.push(nextPos)
                        }
                        break
                    }
                }
            }
        }
    }
    
    private func addBranch() {
        // replace tile that will extend the tree if possible
        for i in 0 ..< resultBoard.n {
            for j in 0 ..< resultBoard.n {
                for dir in Dir.all.shuffled() {
                    let current = resultBoard.tiles[i][j]
                    guard !current.isDir(dir: dir),
                          current != .none else { continue }
                    let adjPos = Pos(x: j, y: i) + dir.pos
                    if adjPos.isValid(boardSize: resultBoard.n) &&
                        adjPos != Pos(x: resultBoard.n - 1, y: resultBoard.n - 1) &&
                        resultBoard.tiles[adjPos.y][adjPos.x] == .none {
                        guard let newTile = Tile(rawValue: current.rawValue ^ dir.rawValue) else {
                            IO.log("Unexpected rawValue \(current.rawValue ^ dir.rawValue)", type: .warn)
                            continue
                        }
                        if tileCounts[newTile.rawValue] > 0 {
//                            IO.log("add: \(current) -> \(newTile), \(Pos(x: j, y: i))", type: .debug)
                            tileCounts[newTile.rawValue] -= 1
                            tileCounts[current.rawValue] += 1
                            resultBoard.place(at: Pos(x: j, y: i), tile: newTile, force: true)
                            allPositions.push(Pos(x: j, y: i))
                        }
                    }
                }
            }
        }
    }
    
    private func trimBranch() {
        // find muda tile, and replace if possible
        for i in 0 ..< resultBoard.n {
            for j in 0 ..< resultBoard.n {
                for dir in Dir.all.shuffled() {
                    let current = resultBoard.tiles[i][j]
                    guard current.isDir(dir: dir) else { continue }
                    let adjPos = Pos(x: j, y: i) + dir.pos
                    if !adjPos.isValid(boardSize: resultBoard.n) ||
                        (resultBoard.tiles[adjPos.y][adjPos.x] != .none && !resultBoard.tiles[adjPos.y][adjPos.x].isDir(dir: dir.rev)) {
                        guard let newTile = Tile(rawValue: current.rawValue ^ dir.rawValue) else {
                            IO.log("Unexpected rawValue \(current.rawValue ^ dir.rawValue)", type: .warn)
                            continue
                        }
                        if tileCounts[newTile.rawValue] > 0 {
//                            IO.log("trim: \(current) -> \(newTile), \(Pos(x: j, y: i))", type: .debug)
                            tileCounts[newTile.rawValue] -= 1
                            tileCounts[current.rawValue] += 1
                            resultBoard.place(at: Pos(x: j, y: i), tile: newTile, force: true)
                        }
                    }
                }
            }
        }
    }
}
