//
//  SwiftBitmaskTests.swift
//  SwiftBitmaskTests
//
//  Created by bryn austin bellomy on 2014 Dec 15.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftBitmask

private enum MonsterAttributes: UInt16, IBitmaskRepresentable
{
    case big   = 1
    case ugly  = 2
    case scary = 4

    var bitmaskValue:   UInt16  { return rawValue }
    init?(bitmaskValue: UInt16) { self.init(rawValue: bitmaskValue) }
}


class SwiftBitmaskTests: XCTestCase
{
    fileprivate let bitmask = MonsterAttributes.Ugly | .Scary

    func testRawTypes() {
        let rawBitmask = Bitmask<UInt16>(12)
        XCTAssert(rawBitmask.bitmaskValue == 12)
    }

    func testSplatConstructor() {
        let b = Bitmask(MonsterAttributes.Big, .Scary)
        XCTAssert(b == MonsterAttributes.Big | MonsterAttributes.Scary)
    }

    func testArrayConstructor() {
        let b = Bitmask([MonsterAttributes.Big, .Scary])
        XCTAssert(b == MonsterAttributes.Big | .Scary)
    }

    func testPrefixOperatorConstructor()
    {
        let singleValue = |MonsterAttributes.Ugly
        XCTAssert(singleValue == MonsterAttributes.Ugly)
        XCTAssert(|MonsterAttributes.Ugly == Bitmask(MonsterAttributes.Ugly))
    }

    func testEquatable() {
        XCTAssert(bitmask == MonsterAttributes.Ugly | .Scary)
    }

    func testComparable() {
        let other = MonsterAttributes.Big | .Scary
        XCTAssert((bitmask <  other) == (bitmask.bitmaskValue <  other.bitmaskValue))
        XCTAssert((bitmask >  other) == (bitmask.bitmaskValue >  other.bitmaskValue))
        XCTAssert((bitmask <= other) == (bitmask.bitmaskValue <= other.bitmaskValue))
        XCTAssert((bitmask >= other) == (bitmask.bitmaskValue >= other.bitmaskValue))
    }

    func testIsSet() {
        XCTAssertTrue(bitmask.isSet(.Ugly))
        XCTAssertTrue(bitmask.isSet(.Scary))
        XCTAssertFalse(bitmask.isSet(.Big))
    }
    
    func testAreSet() {
        XCTAssertTrue(bitmask.areSet(.Ugly, .Scary))
        XCTAssertFalse(bitmask.areSet(.Ugly, .Big))
    }

    func testLogicalOr() {
        XCTAssert(bitmask.bitmaskValue == MonsterAttributes.Ugly.bitmaskValue | MonsterAttributes.Scary.bitmaskValue)
    }

    func testLogicalAnd() {
        let other = MonsterAttributes.ugly
        XCTAssert((bitmask & other) == other)
        XCTAssert((bitmask & other).bitmaskValue == bitmask.bitmaskValue & other.bitmaskValue)
    }

    func testLogicalXor() {
        let other = MonsterAttributes.ugly
        XCTAssert(bitmask ^ other == MonsterAttributes.Scary)
        XCTAssert((bitmask ^ other).bitmaskValue == bitmask.bitmaskValue ^ other.bitmaskValue)
    }

    func testLogicalNot() {
        XCTAssert((~bitmask) == ~(MonsterAttributes.Ugly | .Scary))
    }

    func testNilLiteralConvertible() {
        XCTAssert(bitmask &  MonsterAttributes.Scary != nil)
        XCTAssert(bitmask & |MonsterAttributes.Scary != nil)
    }

    func testBooleanType() {
        XCTAssert(bitmask &  MonsterAttributes.Scary)
        XCTAssert(bitmask & |MonsterAttributes.Scary)
    }

    func testPatternMatchingOperator() {
        // Implements the pattern matching operator
        XCTAssert(bitmask ~=  MonsterAttributes.Scary | .Big)
        XCTAssert(bitmask ~=  MonsterAttributes.Scary)
        XCTAssert(bitmask ~= |MonsterAttributes.Scary)
        XCTAssert((bitmask ~= |MonsterAttributes.Big) == false)
    }
}




