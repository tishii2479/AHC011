//
//  UtilTest.swift
//  AHC011Test
//
//  Created by Tatsuya Ishii on 2022/06/04.
//

import XCTest

class UtilTest: XCTestCase {
    func testUnionFind() throws {
        let uf = GridUnionFind(row: 3, col: 3)
        XCTAssert(uf.merge(Pos(x: 2, y: 2), Pos(x: 2, y: 1)))
        
        
    }

}
