//
//  TileTest.swift
//  AHC011Test
//
//  Created by Tatsuya Ishii on 2022/05/30.
//

import XCTest

class TileTest: XCTestCase {

    func testIsDir() throws {
        for i in 1 ..< (1 << 4) {
            guard let tile = Tile(rawValue: i) else {
                XCTFail("Tile with rawValue \(i) does not exist")
                return
            }
            
            for j in 0 ..< 4 {
                guard (i & (1 << j)) > 0 else { continue }
                guard let dir = Dir(rawValue: (1 << j)) else {
                    XCTFail("Dir with rawValue \(j) does not exist")
                    return
                }

                XCTAssertTrue(tile.isDir(dir: dir))
            }
        }
    }

}
