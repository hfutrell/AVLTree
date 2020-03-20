//
//  main.swift
//  AVLTree
//
//  Created by Holmes Futrell on 3/18/20.
//  Copyright © 2020 Holmes Futrell. All rights reserved.
//

import Foundation

public class AVLTree<T> where T: Comparable {
    var root: AVLNode<T>?
    public func insert(_ value: T) {
        if let root = self.root {
            self.root = root.insert(value)
        } else {
            self.root = AVLNode<T>(value)
        }
    }
}

internal class AVLNode<T> where T: Comparable {
    var height: Int = 0
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

    public func insert(_ value: T) -> AVLNode<T> {
        
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

}

var t = AVLTree<Int>()
for i in 1...500 {
    let value = Int.random(in: 0...1000)
    print("inserting \(value)")
    t.insert(value)
}

print(t)
