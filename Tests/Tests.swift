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
    
    private func checkInvariants<T>(_ tree: AVLTree<T>) -> Bool {
        func height<T>(_ node: AVLNode<T>?) -> Int {
            guard let node = node else { return 0 }
            if let left = node.left {
                if let right = node.right {
                    return 1 + max(height(left), height(right))
                } else {
                    return 1 + height(left)
                }
            } else if let right = node.right {
                return 1 + height(right)
            } else {
                return 1
            }
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
        tree.insert(3)
        tree.insert(5)
        tree.insert(9)  // should cause a left rotation
        XCTAssertEqual(tree.values, [3,5,9])
        XCTAssertTrue(checkInvariants(tree))
        
        tree.insert(2)
        tree.insert(1)  // should cause a right rotation
        XCTAssertEqual(tree.values, [1,2,3,5,9])
        XCTAssertTrue(checkInvariants(tree))

        tree.insert(8)
        tree.insert(10)
        tree.insert(12)
        tree.insert(11) // should cause a right-left rotation
        XCTAssertEqual(tree.values, [1,2,3,5,8,9,10,11,12])
        XCTAssertTrue(checkInvariants(tree))

        tree.insert(6)
        tree.insert(7)  // should cause a left-right rotation
        XCTAssertEqual(tree.values, [1,2,3,5,6,7,8,9,10,11,12])
        XCTAssertTrue(checkInvariants(tree))
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
