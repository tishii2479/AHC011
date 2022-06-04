//
//  MoveTest.swift
//  AHC011Test
//
//  Created by Tatsuya Ishii on 2022/06/01.
//

import XCTest

class MoveTest: XCTestCase {
    
    func testConstructDirs() throws {
        let board = Board(n: 4)
        let startPos = Pos(x: 0, y: 0)
        let endPos = Pos(x: 3, y: 2)
        
        let moves1 = Util.constructDirs(boardSize: board.n, from: startPos, to: endPos, excludePos: [])
        
        XCTAssert(moves1.count == 5)
        
        let excludePos: Set<Pos> = [
            Pos(x: 1, y: 0),
            Pos(x: 1, y: 1),
            Pos(x: 1, y: 2),
        ]
        let moves2 = Util.constructDirs(boardSize: board.n, from: startPos, to: endPos, excludePos: excludePos)
        IO.log(moves2)
        XCTAssert(moves2.count == 7)
        
        let path = Util.convertDirToPath(startPos: startPos, dirs: moves2)
        XCTAssert(path[path.count - 1] == endPos)
    }
    
}
