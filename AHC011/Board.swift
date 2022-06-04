class Board {
    private(set) var tiles: [[Tile]]
    private(set) lazy var zeroTilePos: Pos = {
        for i in 0 ..< n {
            for j in 0 ..< n {
                if tiles[i][j] == .none {
                    return Pos(x: j, y: i)
                }
            }
        }
        IO.log("zero tile is not found", type: .warn)
        return Pos(x: 0, y: 0)
    }()
    
    var n: Int {
        tiles.count
    }
    
    init(n: Int) {
        self.tiles = [[Tile]](repeating: [Tile](repeating: .none, count: n), count: n)
    }
    
    init(tiles: [[Int]]) {
        self.tiles = tiles.map { $0.map { Tile(rawValue: $0) ?? .none } }
    }
    
    func performMoves(moves: [Move]) {
        moves.forEach { performMove(move: $0) }
    }
    
    func performMove(move: Move) {
        let nextPos = zeroTilePos + move.dir.pos
        guard nextPos.isValid(boardSize: n) else {
            IO.log("\(nextPos) is invalid", type: .error)
            fatalError()
        }
        // swap(&_:,&_:) causes fatal error in some reason
        tiles[zeroTilePos.y][zeroTilePos.x] = tiles[nextPos.y][nextPos.x]
        tiles[nextPos.y][nextPos.x] = .none
        zeroTilePos = nextPos
    }
}

// MARK: Place

extension Board {
    @discardableResult
    func place(at pos: Pos, tile placeTile: Tile, force: Bool = false) -> Bool {
        guard pos.isValid(boardSize: n) else {
            IO.log("pos \(pos) is invalid")
            return false
        }
        guard force || isPlaceable(at: pos, tile: placeTile) else {
            IO.log("tile \(placeTile) is not placeable at \(pos)", type: .warn)
            return false
        }
        tiles[pos.y][pos.x] = placeTile
        return true
    }
    
    func isPlaceable(at pos: Pos, tile placeTile: Tile) -> Bool {
        guard pos.isValid(boardSize: n) else {
            IO.log("pos \(pos) is invalid")
            return false
        }
        guard tiles[pos.y][pos.x] == .none else {
            return false
        }
 
        var connectCount = 0
        for dir in Dir.all {
            let checkPos = pos + dir.pos
            // If checkPos is outside the board, use .none as tile
            let checkTile =
                checkPos.isValid(boardSize: n)
                ? tiles[checkPos.y][checkPos.x]
                : .none

            if placeTile.isDir(dir: dir) {
                if checkTile.isDir(dir: dir.rev) {
                    connectCount += 1
                }
                if (checkTile != .none && !checkTile.isDir(dir: dir.rev)) ||
                    !checkPos.isValid(boardSize: n) {
                    // don't allow unconnected tiles
                    return false
                }
            }
        }
        return connectCount == 1
    }
    
    func placeableTiles(at pos: Pos) -> [Tile] {
        Tile.all.filter { isPlaceable(at: pos, tile: $0) }
    }
}

// MARK: Find

extension Board {
    func findTile(tile: Tile, fromPos: Pos, excludePos: Set<Pos>) -> Pos? {
        // TODO: find nearest tile from `fromPos`
        var res: Pos? = nil
        var currentDist: Int = 123456
        for i in 0 ..< n {
            for j in 0 ..< n {
                let pos = Pos(x: j, y: i)
                guard !excludePos.contains(pos) else { continue }
                if tiles[i][j] == tile && fromPos.dist(pos: pos) < currentDist {
                    res = pos
                    currentDist = fromPos.dist(pos: pos)
                }
            }
        }
        return res
    }
}

// MARK: Utilities

extension Board {
    var allTiles: [Tile] {
        var all = [Tile]()
        for row in tiles {
            for tile in row {
                all.append(tile)
            }
        }
        return all
    }
    
    func countTiles() -> [Int] {
        var counter = [Int](repeating: 0, count: tileSize)
        for tile in allTiles {
            counter[tile.rawValue] += 1
        }
        return counter
    }
    
    func log() {
        IO.log(n, type: .none)
        for row in tiles {
            IO.log(
                row.map { "\($0.rawValue)" }.joined(separator: " ")
                , type: .none
            )
        }
    }
}
