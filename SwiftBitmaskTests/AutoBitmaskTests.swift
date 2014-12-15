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


enum AutoMonsterAttributes : String, IBitmaskRepresentable, IAutoBitmaskable
{
    case Big = "big"
    case Ugly = "ugly"
    case Scary = "scary"

    static var autoBitmaskValues : [AutoMonsterAttributes] = [.Big, .Ugly, .Scary,]

    var bitmaskValue:  UInt16  { return AutoBitmask.autoBitmaskValueFor(self) }
    init(bitmaskValue: UInt16) { self = AutoBitmask.autoValueFromBitmask(bitmaskValue) }
}


class AutoBitmaskTests: XCTestCase
{
    func testAutoBitmaskAlgorithmicValues()
    {
        var index = find(AutoMonsterAttributes.autoBitmaskValues, AutoMonsterAttributes.Big)!
        XCTAssert(AutoMonsterAttributes.Big.bitmaskValue == UInt16(1 << index))

        index = find(AutoMonsterAttributes.autoBitmaskValues, AutoMonsterAttributes.Ugly)!
        XCTAssert(AutoMonsterAttributes.Ugly.bitmaskValue == UInt16(1 << index))

        index = find(AutoMonsterAttributes.autoBitmaskValues, AutoMonsterAttributes.Scary)!
        XCTAssert(AutoMonsterAttributes.Scary.bitmaskValue == UInt16(1 << index))
    }

    func testAutoBitmaskConcreteValues()
    {
        XCTAssert(AutoMonsterAttributes.Big.bitmaskValue == 1)
        XCTAssert(AutoMonsterAttributes.Ugly.bitmaskValue == 2)
        XCTAssert(AutoMonsterAttributes.Scary.bitmaskValue == 4)
    }
}





