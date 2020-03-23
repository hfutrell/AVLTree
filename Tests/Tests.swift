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
    func testValues() {
        let tree = AVLTree<Int>()
        XCTAssertEqual(tree.values, [])
        for i in 1...10 {
            tree.insert(i)
        }
        XCTAssertEqual(tree.values, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    }
    func testInsert() {
        let tree = AVLTree<Int>()
        XCTAssertEqual(tree.values, [])
        tree.insert(3)
        tree.insert(5)
        tree.insert(9)  // should cause a left rotation
        tree.insert(2)
        tree.insert(1)  // should cause a right rotation
        tree.insert(8)
        tree.insert(10)
        tree.insert(12)
        tree.insert(11) // should cause a right-left rotation
        tree.insert(6)
        tree.insert(7)  // should cause a left-right rotation
        XCTAssertEqual(tree.values, [1,2,3,5,6,7,8,9,10,11,12])
    }
    func testRemove() {
        
    }
    func testIsEmpty() {
        let tree = AVLTree<String>()
        XCTAssertTrue(tree.isEmpty)
        tree.insert("cat")
        XCTAssertFalse(tree.isEmpty)
        tree.remove("cat")
        XCTAssertTrue(tree.isEmpty)
    }
}
