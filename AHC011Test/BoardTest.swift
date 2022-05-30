//
//  BoardTest.swift
//  AHC011Test
//
//  Created by Tatsuya Ishii on 2022/05/30.
//

import XCTest

class BoardTest: XCTestCase {

    func testIsPlaceable() throws {
        let board = Board(tiles: [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0],
        ])
        
        XCTAssertFalse(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .d))
        XCTAssertFalse(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .l))
        XCTAssertFalse(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .r))
        XCTAssertFalse(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .u))
        
        board.place(at: Pos(x: 0, y: 1), tile: .r, force: true)
        
//        [
//            [0, 0, 0],
//            [r, 0, 0],
//            [0, 0, 0],
//        ])
        
        XCTAssertFalse(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .d))
        XCTAssertTrue(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .l))
        XCTAssertFalse(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .r))
        XCTAssertFalse(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .u))
        
        XCTAssertTrue(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .lr))
        XCTAssertTrue(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .lrd))
        XCTAssertTrue(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .lurd))
        
        board.place(at: Pos(x: 1, y: 0), tile: .rd, force: true)
        
        XCTAssertFalse(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .lu))
        XCTAssertFalse(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .lur))
        XCTAssertTrue(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .lr))
        XCTAssertTrue(board.isPlaceable(at: Pos(x: 1, y: 1), tile: .ud))
//        [
//            [0, rd, 0],
//            [r, 0, 0],
//            [0, 0, 0],
//        ])
    }

}
