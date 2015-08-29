//
//  testFoldrTests.swift
//  testFoldrTests
//
//  Created by sonson on 2015/08/18.
//  Copyright © 2015年 sonson. All rights reserved.
//

import XCTest

extension CollectionType {
    func foldr_recursive<T>(accm:T, f: (Self.Generator.Element, T) -> T) -> T {
        var g = self.generate()
        func next() -> T {
            return g.next().map {x in f(x, next())} ?? accm
        }
        return next()
    }
    
    func foldr_loop<T>(accm:T, @noescape f: (Self.Generator.Element, T) -> T) -> T {
        var result = accm
        for temp in self.reverse() {
            result = f(temp, result)
        }
        return result
    }
    
    func foldr_forEach<T>(accm:T, @noescape f: (Self.Generator.Element, T) -> T) -> T {
        var result = accm
        self.reverse().forEach { (t) -> () in
            result = f(t, result)
        }
        return result
    }
    
    func foldr_reduce<T>(accm:T, @noescape f: (T, Self.Generator.Element) -> T) -> T {
        return self.reverse().reduce(accm) { f($0, $1) }
    }
    
    func foldl_reduce<T>(accm:T, @noescape f: (T, Self.Generator.Element) -> T) -> T {
        return self.reduce(accm) { f($0, $1) }
    }
}

extension CollectionType where Index : RandomAccessIndexType {
    func foldr_loop2<T>(accm:T, @noescape f: (Self.Generator.Element, T) -> T) -> T {
        var result = accm
        for temp in self.reverse() {
            result = f(temp, result)
        }
        return result
    }
    
    func foldr_reduce2<T>(accm:T, @noescape f: (T, Self.Generator.Element) -> T) -> T {
        return self.reverse().reduce(accm) { f($0, $1) }
    }
    
    func foldr_forEach2<T>(accm:T, @noescape f: (Self.Generator.Element, T) -> T) -> T {
        var result = accm
        self.reverse().forEach { (t) -> () in
            result = f(t, result)
        }
        return result
    }
}

class foldrTests: XCTestCase {
    var data:[Int] = []
    let count = 1000
    let loop = 1000
    override func setUp() {
        super.setUp()
        if data.count == 0 {
            data.removeAll()
            for var i = 0; i < count; i++ {
                data.append(Int(arc4random() % 10 + 1))
            }
        }
    }
    
    func test_ref_foldl() {
        self.measureBlock {
            for var i = 0; i < self.loop; i++ {
                self.data.foldl_reduce(1) { (x, accm) -> Int in
                    return accm + x / 2
                }
            }
        }
    }
    
    func test_foldr_recursive() {
        if count <= 1000 {
            self.measureBlock {
                for var i = 0; i < self.loop; i++ {
                    self.data.foldr_recursive(1) { (x, accm) -> Int in
                        return accm + x / 2
                    }
                }
            }
        }
    }
    
    func test_foldr_loop() {
        self.measureBlock {
            for var i = 0; i < self.loop; i++ {
                self.data.foldr_loop(1) { (x, accm) -> Int in
                    return accm + x / 2
                }
            }
        }
    }
    
    func test_foldr_loop2() {
        self.measureBlock {
            for var i = 0; i < self.loop; i++ {
                self.data.foldr_loop2(1) { (x, accm) -> Int in
                    return accm + x / 2
                }
            }
        }
    }
    
    func test_foldr_forEach() {
        self.measureBlock {
            for var i = 0; i < self.loop; i++ {
                self.data.foldr_forEach(1, f: { (x, accm) -> Int in
                    return accm + x / 2
                })
            }
        }
    }
    
    func test_foldr_forEach2() {
        self.measureBlock {
            for var i = 0; i < self.loop; i++ {
                self.data.foldr_forEach2(1, f: { (x, accm) -> Int in
                    return accm + x / 2
                })
            }
        }
    }
    
    func test_foldr_reduce() {
        self.measureBlock {
            for var i = 0; i < self.loop; i++ {
                self.data.foldr_reduce(1) { (x, accm) -> Int in
                    return accm + x / 2
                }
            }
        }
    }
    
    func test_foldr_reduce2() {
        self.measureBlock {
            for var i = 0; i < self.loop; i++ {
                self.data.foldr_reduce2(1) { (x, accm) -> Int in
                    return accm + x / 2
                }
            }
        }
    }
}