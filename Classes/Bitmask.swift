//
//  Bitmask.swift
//  SwiftBitmask
//
//  Created by bryn austin bellomy on 2014 Nov 21.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


public protocol IBitmaskRepresentable
{
    typealias BitmaskRawType : IBitmaskRawType
    var bitmaskValue : BitmaskRawType { get }
}

public protocol IBitmaskInitializable
{
    typealias BitmaskRawType : IBitmaskRawType
    init(bitmaskValue:BitmaskRawType)
}

public protocol IBitmaskRawType : BitwiseOperationsType, Equatable, Comparable
{
    init(_ v:Int)
}


public struct Bitmask<T : IBitmaskRepresentable> : BitwiseOperationsType
{
    public typealias BitmaskRawType = T.BitmaskRawType

    public private(set) var bitmaskValue : BitmaskRawType = BitmaskRawType.allZeros

    public static var allOnes  : Bitmask<T> { return Bitmask(~T.BitmaskRawType.allZeros) }
    public static var allZeros : Bitmask<T> { return Bitmask(T.BitmaskRawType.allZeros)  }
    public var isAllOnes  : Bool { return self == Bitmask.allOnes  }
    public var isAllZeros : Bool { return self == Bitmask.allZeros }

    public init() {}
    public init(_ val: T.BitmaskRawType) { setValue(val) }
    public init(_ val: [T])                     { setValue(val) }
    public init(_ val: T...)                    { setValue(val) }
    public init(_ val: [T.BitmaskRawType])      { setValue(val) }
    public init(_ val: T.BitmaskRawType...)     { setValue(val) }
    public init(_ val: Bitmask<T>...)           { setValue(val) }


    public mutating func setValue(val: T)                { bitmaskValue = val.bitmaskValue }
    public mutating func setValue(val: T.BitmaskRawType) { bitmaskValue = val }

    public mutating func setValue(val:[T]) {
        let logicallyORed = val.map { $0.bitmaskValue }
                               .reduce(T.BitmaskRawType.allZeros) { $0 | $1 }
        setValue(logicallyORed)
    }

    public mutating func setValue(val: [T.BitmaskRawType]) {
        let logicallyORed = val.reduce(T.BitmaskRawType.allZeros) { $0 | $1 }
        setValue(logicallyORed)
    }

    public mutating func setValue(val:[Bitmask<T>]) {
        let rawValues = map(val) { $0.bitmaskValue }
        setValue(rawValues)
    }
}


extension Bitmask : IBitmaskRepresentable
{
    public init<U : IBitmaskRepresentable>(_ vals: [U]) {
        let arr = map(vals) { $0.bitmaskValue as T.BitmaskRawType }
        self.init(arr)
    }
}



//
// MARK: - Bitmask : Equatable -
//

extension Bitmask : Equatable {}

public func == <T>(lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bool {
    return lhs.bitmaskValue == rhs.bitmaskValue
}



//
// MARK: - Bitmask : Comparable -
//

extension Bitmask : Comparable {}

public func < <T>(lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bool {
    return lhs.bitmaskValue < rhs.bitmaskValue
}





extension Bitmask : NilLiteralConvertible
{
    public init(nilLiteral: ())
    {
        self = Bitmask(BitmaskRawType.allZeros)
    }
}


extension Bitmask : BooleanType
{
    public var boolValue : Bool { return !isAllZeros }
}



//
// MARK: - Operators -
// MARK: - Quick instantiation prefix operator
//

prefix operator | {}

public prefix func | <T : IBitmaskRepresentable>(val:T) -> Bitmask<T> {
    return Bitmask<T>(val)
}



//
// MARK: - Bitwise OR
//

public func | <T : IBitmaskRepresentable>(lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bitmask<T> { return Bitmask(lhs.bitmaskValue | rhs.bitmaskValue) }
public func | <T : IBitmaskRepresentable>(lhs:Bitmask<T>, rhs:T)          -> Bitmask<T> { return Bitmask(lhs.bitmaskValue | rhs.bitmaskValue) }
public func | <T : IBitmaskRepresentable>(lhs:T, rhs:Bitmask<T>)          -> Bitmask<T> { return rhs | lhs }
public func | <T : IBitmaskRepresentable>(lhs:T, rhs:T)                   -> Bitmask<T> { return Bitmask(lhs.bitmaskValue | rhs.bitmaskValue) }

public func |= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T>, rhs:T)          { lhs.setValue(lhs.bitmaskValue | rhs.bitmaskValue) }
public func |= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T>, rhs:Bitmask<T>) { lhs.setValue(lhs.bitmaskValue | rhs.bitmaskValue) }



//
// MARK: - Bitwise AND
//

public func & <T : IBitmaskRepresentable>(lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bitmask<T> { return Bitmask(lhs.bitmaskValue & rhs.bitmaskValue) }
public func & <T : IBitmaskRepresentable>(lhs:Bitmask<T>, rhs:T)          -> Bitmask<T> { return Bitmask(lhs.bitmaskValue & rhs.bitmaskValue) }
public func & <T : IBitmaskRepresentable>(lhs:T,          rhs:Bitmask<T>) -> Bitmask<T> { return rhs & lhs }
public func & <T : IBitmaskRepresentable>(lhs:T, rhs:T)                   -> Bitmask<T> { return Bitmask(lhs.bitmaskValue & rhs.bitmaskValue) }

public func &= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T>, rhs:T)          { lhs.setValue(lhs.bitmaskValue & rhs.bitmaskValue) }
public func &= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T>, rhs:Bitmask<T>) { lhs.setValue(lhs.bitmaskValue & rhs.bitmaskValue) }



//
// MARK: - Bitwise XOR
//

public func ^ <T : IBitmaskRepresentable>(lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bitmask<T> { return Bitmask(lhs.bitmaskValue ^ rhs.bitmaskValue) }
public func ^ <T : IBitmaskRepresentable>(lhs:Bitmask<T>, rhs:T)          -> Bitmask<T> { return Bitmask(lhs.bitmaskValue ^ rhs.bitmaskValue) }
public func ^ <T : IBitmaskRepresentable>(lhs:T, rhs:Bitmask<T>)          -> Bitmask<T> { return rhs ^ lhs }
public func ^ <T : IBitmaskRepresentable>(lhs:T, rhs:T)                   -> Bitmask<T> { return Bitmask(lhs.bitmaskValue ^ rhs.bitmaskValue) }

public func ^= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T>, rhs:T)          { lhs.setValue(lhs.bitmaskValue ^ rhs.bitmaskValue) }
public func ^= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T>, rhs:Bitmask<T>) { lhs.setValue(lhs.bitmaskValue ^ rhs.bitmaskValue) }



//
// MARK: - Bitwise NOT
//

public prefix func ~ <T : IBitmaskRepresentable>(value:Bitmask<T>) -> Bitmask<T> { return Bitmask(~(value.bitmaskValue)) }
public prefix func ~ <T : IBitmaskRepresentable>(value:T)          -> Bitmask<T> { return Bitmask(~(value.bitmaskValue)) }



//
// MARK: - Pattern matching operator
//

public func ~=<T : IBitmaskRepresentable>(pattern: Bitmask<T>, value: Bitmask<T>) -> Bool { return (pattern & value).boolValue }
public func ~=<T : IBitmaskRepresentable>(pattern: Bitmask<T>, value: T) -> Bool          { return (pattern & value).boolValue }
public func ~=<T : IBitmaskRepresentable>(pattern: T, value: Bitmask<T>) -> Bool          { return (pattern & value).boolValue }



//
// MARK: - Built-in type conformance to IBitmaskRawType
//

extension Int    : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = Int
    public var bitmaskValue : Int { return self }
}
extension Int8   : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = Int8
    public var bitmaskValue : Int8 { return self }
}
extension Int16  : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = Int16
    public var bitmaskValue : Int16 { return self }
}
extension Int32  : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = Int32
    public var bitmaskValue : Int32 { return self }
}
extension Int64  : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = Int64
    public var bitmaskValue : Int64 { return self }
}
extension UInt   : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = UInt
    public var bitmaskValue : UInt { return self }
}
extension UInt8  : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = UInt8
    public var bitmaskValue : UInt8 { return self }
}
extension UInt16 : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = UInt16
    public var bitmaskValue : UInt16 { return self }
}
extension UInt32 : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = UInt32
    public var bitmaskValue : UInt32 { return self }
}
extension UInt64 : IBitmaskRepresentable, IBitmaskRawType {
    public typealias BitmaskRawType = UInt64
    public var bitmaskValue : UInt64 { return self }
}




