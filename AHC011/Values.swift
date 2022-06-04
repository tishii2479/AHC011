import Foundation

// For time management
let runLimitDate = Date().addingTimeInterval(2.7)
let tileSize = 16

struct Move {
    var dir: Dir
    
    var str: String {
        switch dir {
        case .left:
            return "L"
        case .up:
            return "U"
        case .right:
            return "R"
        case .down:
            return "D"
        }
    }
}

enum Dir: Int {
    case left   = 0b0001
    case up     = 0b0010
    case right  = 0b0100
    case down   = 0b1000

    static let all: [Dir] = [
        .left, .up, .right, .down
    ]
    
    var pos: Pos {
        switch self {
        case .left:
            return Pos(x: -1, y: 0)
        case .up:
            return Pos(x: 0, y: -1)
        case .right:
            return Pos(x: 1, y: 0)
        case .down:
            return Pos(x: 0, y: 1)
        }
    }
    
    var rev: Dir {
        switch self {
        case .left:
            return .right
        case .up:
            return .down
        case .right:
            return .left
        case .down:
            return .up
        }
    }
}

enum Tile: Int {
    case none   = 0b0000
    case l      = 0b0001
    case u      = 0b0010
    case lu     = 0b0011
    case r      = 0b0100
    case lr     = 0b0101
    case ur     = 0b0110
    case lur    = 0b0111
    case d      = 0b1000
    case ld     = 0b1001
    case ud     = 0b1010
    case lud    = 0b1011
    case rd     = 0b1100
    case lrd    = 0b1101
    case urd    = 0b1110
    case lurd   = 0b1111
    
    func isDir(dir: Dir) -> Bool {
        (rawValue & dir.rawValue) > 0
    }
    
    static let all: [Tile] = [
        .l, .u, .lu, .r,
        .lr, .ur, .lur, .d,
        .ld, .ud, .lud, .rd,
        .lrd, .urd, .lurd
    ]
}

struct Pos: Hashable {
    var x: Int
    var y: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension Pos {
    func isValid(boardSize: Int) -> Bool {
        x >= 0 && y >= 0 && x < boardSize && y < boardSize
    }
}

extension Pos {
    static func ==(lhs: Pos, rhs: Pos) -> Bool {
        lhs.y == rhs.y && lhs.x == rhs.x
    }
    
    static func !=(lhs: Pos, rhs: Pos) -> Bool {
        !(lhs == rhs)
    }
    
    static func +=(lhs: inout Pos, rhs: Pos) {
        lhs.y += rhs.y
        lhs.x += rhs.x
    }
    
    static func +(lhs: Pos, rhs: Pos) -> Pos {
        Pos(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

extension Pos {
    func dist(pos: Pos) -> Int {
        abs(x - pos.x) + abs(y - pos.y)
    }
}
