//
//  AutoBitmaskTests.swift
//  SwiftBitmask
//
//  Created by bryn austin bellomy on 2014 Dec 15.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftBitmask


private enum MonsterAttributes : String, IBitmaskRepresentable, IAutoBitmaskable
{
    case Big = "big"
    case Ugly = "ugly"
    case Scary = "scary"

    static var autoBitmaskValues : [MonsterAttributes] = [.Big, .Ugly, .Scary,]

    var bitmaskValue:  UInt16  { return AutoBitmask.autoBitmaskValueFor(self) }
    init(bitmaskValue: UInt16) { self = AutoBitmask.autoValueFromBitmask(bitmaskValue) }
}


class AutoBitmaskTests: XCTestCase
{
    func testAutoBitmaskAlgorithmicValues()
    {
        var index = MonsterAttributes.autoBitmaskValues.index(of: MonsterAttributes.Big)!
        XCTAssert(MonsterAttributes.Big.bitmaskValue == UInt16(1 << index))

        index = MonsterAttributes.autoBitmaskValues.index(of: MonsterAttributes.Ugly)!
        XCTAssert(MonsterAttributes.Ugly.bitmaskValue == UInt16(1 << index))

        index = MonsterAttributes.autoBitmaskValues.index(of: MonsterAttributes.Scary)!
        XCTAssert(MonsterAttributes.Scary.bitmaskValue == UInt16(1 << index))
    }

    func testAutoBitmaskConcreteValues()
    {
        XCTAssert(MonsterAttributes.Big.bitmaskValue == 1)
        XCTAssert(MonsterAttributes.Ugly.bitmaskValue == 2)
        XCTAssert(MonsterAttributes.Scary.bitmaskValue == 4)
    }
}





