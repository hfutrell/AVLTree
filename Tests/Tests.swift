//
//  Tests.swift
//  Tests
//
//  Created by Holmes Futrell on 3/22/20.
//  Copyright © 2020 Holmes Futrell. All rights reserved.
//

import XCTest
@testable import AVLTree

class Tests: XCTestCase {
    private func insertHelper<T>(_ tree: AVLTree<T>, _ array: [T]) {
        array.forEach { tree.insert($0) }
    }
    private func checkInvariants<T>(_ tree: AVLTree<T>) -> Bool {
        func height<T>(_ node: AVLNode<T>?) -> Int {
            guard let node = node else { return 0 }
            return 1 + max(height(node.left), height(node.right))
        }
        func checkInvariants<T>(_ node: AVLNode<T>) -> Bool {
            let leftHeight = height(node.left)
            let rightHeight = height(node.right)
            if abs(leftHeight - rightHeight) > 1 {
                return false // node is imbalanced
            }
            if let left = node.left, !checkInvariants(left){
                return false // left child is imbalanced
            }
            if let right = node.right, !checkInvariants(right) {
                return false // right child is imbalanced
            }
            return true // node is balanced
        }
        guard let root = tree.root else { return true }
        return checkInvariants(root)
    }
    func testInsert() {
        let tree = AVLTree<Int>()
        XCTAssertEqual(tree.values, [])
        insertHelper(tree, [3,5,9]) // insertion of 9 should cause a left rotation
        XCTAssertEqual(tree.values, [3,5,9])
        XCTAssertTrue(checkInvariants(tree))
        
        insertHelper(tree, [2, 1]) // insertion of 1 should cause a right rotation
        XCTAssertEqual(tree.values, [1,2,3,5,9])
        XCTAssertTrue(checkInvariants(tree))

        insertHelper(tree, [8,10,12,11]) // insertion of 11 should cause a right-left rotation
        XCTAssertEqual(tree.values, [1,2,3,5,8,9,10,11,12])
        XCTAssertTrue(checkInvariants(tree))

        insertHelper(tree, [6,7]) // insertion of 7 should cause a left-right rotation
        XCTAssertEqual(tree.values, [1,2,3,5,6,7,8,9,10,11,12])
        XCTAssertTrue(checkInvariants(tree))
    }
    func testRemoveBasic() {
        // basic removal test code that does not require rebalancing
        let tree = AVLTree<Double>()
        tree.remove(1) // attempt to remove a value from empty tree
        XCTAssertEqual(tree.values, [])
        
        insertHelper(tree, [2,1,3])
        tree.remove(2) // root should be replaced by right successor
        XCTAssertEqual(tree.values, [1,3])
        XCTAssertTrue(checkInvariants(tree))

        tree.remove(3) // no-right successor, replace with left
        XCTAssertEqual(tree.values, [1])
        XCTAssertTrue(checkInvariants(tree))

        tree.remove(1) // no-child nodes
        XCTAssertEqual(tree.values, [])

        insertHelper(tree, [3,2,5,1,4,7,6])
        tree.remove(5) // remove from right sub-tree, replacing with 6
        XCTAssertEqual(tree.values, [1,2,3,4,6,7])
        XCTAssertTrue(checkInvariants(tree))

        tree.remove(6) // remove 6, replacing it with 7
        XCTAssertEqual(tree.values, [1,2,3,4,7])
        XCTAssertTrue(checkInvariants(tree))

        tree.remove(2) // remove 2, replacing it with 1
        XCTAssertEqual(tree.values, [1,3,4,7])
        XCTAssertTrue(checkInvariants(tree))
        
        insertHelper(tree, [2,8,3.5])
        tree.remove(3) // remove 3 by replacing it with 3.5
        XCTAssertEqual(tree.values, [1,2,3.5,4,7,8])
        XCTAssertTrue(checkInvariants(tree))
    }
    func testRemoveRebalance() {
        // tests removal of nodes that requires the tree to rebalance
        var tree = AVLTree<Int>()
        insertHelper(tree, [5,4,7,3,6,8,9])
        tree.remove(5) // should be replaced with 6, causing a left-right rotation
        XCTAssertEqual(tree.values, [3,4,6,7,8,9])
        XCTAssertTrue(checkInvariants(tree))

        tree = AVLTree<Int>()
        insertHelper(tree, [2,1,4,5])
        tree.remove(1) // should cause a left rotation
        XCTAssertEqual(tree.values, [2,4,5])
        XCTAssertTrue(checkInvariants(tree))

        tree = AVLTree<Int>()
        insertHelper(tree, [3,1,4,0])
        tree.remove(4) // should cause a right rotation
        XCTAssertEqual(tree.values, [0,1,3])
        XCTAssertTrue(checkInvariants(tree))
        
        tree = AVLTree<Int>()
        insertHelper(tree, [5,3,10,2,4,7,11,1,6,9,12,8])
        tree.remove(5) // root node gets replaced by 6, whose removal requires a rotation
        XCTAssertEqual(tree.values, [1,2,3,4,6,7,8,9,10,11,12])
        XCTAssertTrue(checkInvariants(tree))

        tree = AVLTree<Int>()
        insertHelper(tree, [3,2,4,1])
        tree.remove(3) // root node gets replaced by 4, and requires rotation
        XCTAssertEqual(tree.values, [1,2,4])
        XCTAssertTrue(checkInvariants(tree))
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
