class Board {
    private(set) var tiles: [[Tile]]
    
    var n: Int {
        tiles.count
    }
    
    init(n: Int) {
        self.tiles = [[Tile]](repeating: [Tile](repeating: .none, count: n), count: n)
    }
    
    init(tiles: [[Int]]) {
        self.tiles = tiles.map { $0.map { Tile(rawValue: $0) ?? .none } }
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
                if checkTile != .none && !checkTile.isDir(dir: dir.rev) ||
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
                row.map { String($0.rawValue) }.joined(separator: " ")
                , type: .none
            )
        }
    }
}
