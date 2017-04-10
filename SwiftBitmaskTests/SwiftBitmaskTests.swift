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
    fileprivate let bitmask = MonsterAttributes.ugly | .scary

    func testRawTypes() {
        let rawBitmask = Bitmask<UInt16>(12)
        XCTAssert(rawBitmask.bitmaskValue == 12)
    }

    func testSplatConstructor() {
        let b = Bitmask(MonsterAttributes.big, .scary)
        XCTAssert(b == MonsterAttributes.big | MonsterAttributes.scary)
    }

    func testArrayConstructor() {
        let b = Bitmask([MonsterAttributes.big, .scary])
        XCTAssert(b == MonsterAttributes.big | .scary)
    }

    func testPrefixOperatorConstructor()
    {
        let singleValue = |MonsterAttributes.ugly
        XCTAssert(singleValue == MonsterAttributes.ugly)
        XCTAssert(|MonsterAttributes.ugly == Bitmask(MonsterAttributes.ugly))
    }

    func testEquatable() {
        XCTAssert(bitmask == MonsterAttributes.ugly | .scary)
    }

    func testComparable() {
        let other = MonsterAttributes.big | .scary
        XCTAssert((bitmask <  other) == (bitmask.bitmaskValue <  other.bitmaskValue))
        XCTAssert((bitmask >  other) == (bitmask.bitmaskValue >  other.bitmaskValue))
        XCTAssert((bitmask <= other) == (bitmask.bitmaskValue <= other.bitmaskValue))
        XCTAssert((bitmask >= other) == (bitmask.bitmaskValue >= other.bitmaskValue))
    }

    func testIsSet() {
        XCTAssertTrue(bitmask.isSet(.ugly))
        XCTAssertTrue(bitmask.isSet(.scary))
        XCTAssertFalse(bitmask.isSet(.big))
    }
    
    func testAreSet() {
        XCTAssertTrue(bitmask.areSet(.ugly, .scary))
        XCTAssertFalse(bitmask.areSet(.ugly, .big))
    }

    func testLogicalOr() {
        XCTAssert(bitmask.bitmaskValue == MonsterAttributes.ugly.bitmaskValue | MonsterAttributes.scary.bitmaskValue)
    }

    func testLogicalAnd() {
        let other = MonsterAttributes.ugly
        XCTAssert((bitmask & other) == other)
        XCTAssert((bitmask & other).bitmaskValue == bitmask.bitmaskValue & other.bitmaskValue)
    }

    func testLogicalXor() {
        let other = MonsterAttributes.ugly
        XCTAssert(bitmask ^ other == MonsterAttributes.scary)
        XCTAssert((bitmask ^ other).bitmaskValue == bitmask.bitmaskValue ^ other.bitmaskValue)
    }

    func testLogicalNot() {
        XCTAssert((~bitmask) == ~(MonsterAttributes.ugly | .scary))
    }

    func testNilLiteralConvertible() {
        XCTAssert(bitmask &  MonsterAttributes.scary != nil)
        XCTAssert(bitmask & |MonsterAttributes.scary != nil)
    }

    func testBooleanType() {
        XCTAssert((bitmask &  MonsterAttributes.scary).boolValue)
        XCTAssert((bitmask & |MonsterAttributes.scary).boolValue)
    }

    func testPatternMatchingOperator() {
        // Implements the pattern matching operator
        XCTAssert(bitmask ~=  MonsterAttributes.scary | .big)
        XCTAssert(bitmask ~=  MonsterAttributes.scary)
        XCTAssert(bitmask ~= |MonsterAttributes.scary)
        XCTAssert((bitmask ~= |MonsterAttributes.big) == false)
    }
}




