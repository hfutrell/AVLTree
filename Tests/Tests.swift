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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let t = AVLTree<Int>()
        for i in 1...500 {
            let value = Int.random(in: 0...1000)
            print("inserting \(value)")
            t.insert(value)
        }
        print(t)
    }
}
