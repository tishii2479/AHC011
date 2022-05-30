class Board {
    private var tiles: [[Tile]]
    private var isTree: [[Bool]]
    
    var n: Int {
        tiles.count
    }
    
    init(tiles: [[Int]]) {
        self.tiles = tiles.map { $0.map { Tile(rawValue: $0) ?? .none } }
        self.isTree = tiles.map { $0.map { _ in false } }
    }
}

// MARK: Place

extension Board {
    @discardableResult
    func place(at pos: Pos, tile placeTile: Tile, force: Bool = false) -> Bool {
        guard isPlaceable(at: pos, tile: placeTile) || force else {
            IO.log("tile \(placeTile) is not placeable at \(pos)", type: .warn)
            return false
        }
        tiles[pos.y][pos.x] = placeTile
        return true
    }
    
    func isPlaceable(at pos: Pos, tile placeTile: Tile) -> Bool {
        var connectCount = 0
        for dir in Dir.all {
            let checkPos = pos + dir.pos
            guard checkPos.isValid(boardSize: n) else { continue }
            let checkTile = tiles[checkPos.y][checkPos.x]
            if checkTile.isDir(dir: dir.rev) && placeTile.isDir(dir: dir) {
                connectCount += 1
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
}
