//
//  Tests.swift
//  Tests
//
//  Created by Holmes Futrell on 3/22/20.
//  Copyright © 2020 Holmes Futrell. All rights reserved.
//

import XCTest
import AVLTree

class Tests: XCTestCase {
    func testInsert() {
        
    }
    func testRemove() {
        
    }
    func testValues() {
        let tree = AVLTree<Int>()
        for i in 1...10 {
            tree.insert(i)
        }
        XCTAssertEqual(tree.values, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    }
    func testIsEmpty() {
        let tree = AVLTree<String>()
        XCTAssertTrue(tree.isEmpty, "tree should begin empty.")
        tree.insert("cat")
        XCTAssertFalse(tree.isEmpty, "tree is not empty with cat in it.")
        tree.remove("cat")
        XCTAssertTrue(tree.isEmpty, "tree should be empty once cat is removed.")
    }
}
