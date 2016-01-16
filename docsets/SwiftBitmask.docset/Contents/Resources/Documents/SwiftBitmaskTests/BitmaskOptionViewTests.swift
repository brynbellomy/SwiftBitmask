//
//  BitmaskOptionViewTests.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Dec 22.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest


public enum ColliderType : String
{
    case None = "none"
    case Hero = "hero"
    case Enemy = "enemy"
    case Projectile = "projectile"
    case Wall = "wall"
    case EnvironmentalObject = "environmental object"
}

extension ColliderType : IBitmaskRepresentable {
    public var bitmaskValue : UInt32 { return AutoBitmask.autoBitmaskValueFor(self) }
}

extension ColliderType : IAutoBitmaskable {
    public static var autoBitmaskValues : [ColliderType] { return [ .None, .Hero, .Enemy, .Projectile, .Wall, .EnvironmentalObject, ] }
}

extension ColliderType : IConfigRepresentable
{
    public init?(configValue:String)
    {
        if let configStr = configValue as? String {
            if let obj = ColliderType(rawValue: configStr.lowercaseString)? {
                self = obj
            }
            else { return nil }
        }
        else { return nil }
    }
}




class BitmaskOptionViewTests: XCTestCase
{
    var bitmaskOptionView : ConfigBitmaskOptionView<ColliderType>?

    override func setUp()
    {
        super.setUp()
        bitmaskOptionView = ConfigBitmaskOptionView<ColliderType>(config:config)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
