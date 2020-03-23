//
//  main.swift
//  AVLTree
//
//  Created by Holmes Futrell on 3/18/20.
//  Copyright © 2020 Holmes Futrell. All rights reserved.
//

import Foundation

/// A self-balancing binary search tree that maintains an ordered collection of elements with efficient `O(log(n))` insertion and deletion operations.
public class AVLTree<T> where T: Comparable {
    internal var root: AVLNode<T>?
    /// creates an empty AVL Tree
    public init() { }
    /// inserts a value into the tree
    /// - Parameter value: the value to be inserted
    public func insert(_ value: T) {
        if let root = self.root {
            self.root = root.insert(value)
        } else {
            self.root = AVLNode<T>(value)
        }
    }
    /// removes a single occurrence of a value from the tree
    /// - Parameter value: the element to be removed
    public func remove(_ value: T) {
        guard let root = self.root else { return } // nothing to do
        self.root = root.remove(value)
    }
    /// A Boolean value that indicates whether the tree is empty
    public var isEmpty: Bool { return self.root == nil }
    /// An ordered collection of the entries contained in the tree.
    public var values: [T] {
        guard let root = self.root else { return [] }
        var result: [T] = []
        root.preorderTraversal { result.append($0) }
        return result
    }
}

internal class AVLNode<T> where T: Comparable {
    var height: Int = 1
    var value: T
    var left, right: AVLNode?
        
    var balance: Int {
        return self.leftHeight - self.rightHeight
    }
    
    var leftHeight: Int {
        return self.left?.height ?? 0
    }
    
    var rightHeight: Int {
        return self.right?.height ?? 0
    }
    
    var isLeaf: Bool { return self.left == nil && self.right == nil }
    
    init(_ value: T) {
        self.value = value
    }

    private func rotateRight() -> AVLNode<T> {
        let b = self.left!
        self.left = b.right
        b.right = self
        self.recalculateHeight()
        b.recalculateHeight()
        return b
    }
    
    private func rotateLeft() -> AVLNode<T> {
        let b = self.right!
        self.right = b.left
        b.left = self
        self.recalculateHeight()
        b.recalculateHeight()
        return b
    }
    
    private func rotateLeftRight() -> AVLNode<T> {
        self.left = self.left!.rotateLeft()
        self.recalculateHeight()
        return self.rotateRight()
    }

    private func rotateRightLeft() -> AVLNode<T> {
        self.right = self.right!.rotateRight()
        self.recalculateHeight()
        return self.rotateLeft()
    }

    private func recalculateHeight() {
        self.height = 1 + max(self.leftHeight, self.rightHeight)
    }

    internal func insert(_ value: T) -> AVLNode<T> {
        
        defer { self.recalculateHeight() }
        
        if value < self.value {
            if let left = self.left {
                self.left = left.insert(value)
                if self.balance > 1 {
                    if let leftBalance = self.left?.balance, leftBalance > 0 {
                        return self.rotateRight()
                    } else {
                        return self.rotateLeftRight()
                    }
                }
            } else {
                self.left = AVLNode<T>(value)
                return self
            }
        } else {
            if let right = self.right {
                self.right = right.insert(value)
                if self.balance < -1 {
                    if let rightBalance = self.right?.balance, rightBalance < 0 {
                        return self.rotateLeft()
                    } else {
                        return self.rotateRightLeft()
                    }
                }
            } else {
                self.right = AVLNode<T>(value)
                return self
            }
        }
        return self
    }
    
    private func removeSuccessor() -> AVLNode<T>? {
        defer { self.recalculateHeight() }
        if let left = self.left {
            if left.isLeaf {
                self.left = nil
                return left
            } else {
                return left.removeSuccessor()
            }
        } else if let right = self.right {
            if right.isLeaf {
                self.right = nil
                return right
            } else {
                return right.removeSuccessor()
            }
        } else {
            return nil // we are a leaf-node (no successor)
        }
    }
    
    internal func remove(_ value: T) -> AVLNode<T>? {
        if value < self.value, let left = self.left {
            // remove the value from the left sub-tree
            self.left = left.remove(value)
            self.recalculateHeight()
            return self
        } else if value > self.value, let right = self.right {
            // remove the value from the right sub-tree
            self.right = right.remove(value)
            self.recalculateHeight()
            return self
        } else {
            if let sucessor = self.removeSuccessor() {
                sucessor.left = self.left
                sucessor.right = self.right
                sucessor.recalculateHeight()
                return sucessor
            } else if let left = self.left {
                // no successor node, replace self with left-child (if it exists)
                return left
            } else {
                // no child nodes
                return nil
            }
        }
    }
    
    internal func preorderTraversal(_ callback: (T) -> Void) {
        self.left?.preorderTraversal(callback)
        callback(self.value)
        self.right?.preorderTraversal(callback)
    }
}
