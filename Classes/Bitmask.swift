//
//  Bitmask.swift
//  SwiftBitmask
//
//  Created by bryn austin bellomy on 2014 Nov 21.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky


public protocol IBitmaskRepresentable
{
    typealias BitmaskRawType: IBitmaskRawType
    var bitmaskValue: BitmaskRawType { get }
}


public protocol IBitmaskRawType: BitwiseOperationsType, Equatable, Comparable
{
    init(_ v:Int)
}


public struct Bitmask <T: IBitmaskRepresentable> : BitwiseOperationsType
{
    public typealias BitmaskRawType = T.BitmaskRawType

    public private(set) var bitmaskValue: BitmaskRawType = BitmaskRawType.allZeros

    public static var allZeros: Bitmask<T> { return Bitmask(T.BitmaskRawType.allZeros)  }
    public var isAllZeros: Bool { return self == Bitmask.allZeros }

    public init() {}
    public init(_ val: T.BitmaskRawType)        { setValue(val) }
    public init(_ val: [T])                     { setValue(val) }
    public init(_ val: T...)                    { setValue(val) }
    public init(_ val: [T.BitmaskRawType])      { setValue(val) }
    public init(_ val: T.BitmaskRawType...)     { setValue(val) }
    public init(_ val: Bitmask<T>...)           { setValue(val) }


    public mutating func setValue(val: T)                { bitmaskValue = val.bitmaskValue }
    public mutating func setValue(val: T.BitmaskRawType) { bitmaskValue = val }

    public mutating func setValue(val: [T])
    {
        val |> mapr { $0.bitmaskValue }
            |> reducer(T.BitmaskRawType.allZeros) { $0 | $1 }
            |> setValue
    }

    public mutating func setValue(val: [T.BitmaskRawType])
    {
        val |> reducer(T.BitmaskRawType.allZeros) { $0 | $1 }
            |> setValue
    }

    public mutating func setValue(val: [Bitmask<T>])
    {
        val |> mapr { $0.bitmaskValue }
            |> setValue
    }
}


extension Bitmask: IBitmaskRepresentable
{
    public init <U: IBitmaskRepresentable> (_ vals: [U])
    {
        let arr = vals |> mapr { $0.bitmaskValue as T.BitmaskRawType }
        self.init(arr)
    }
}



//
// MARK: - Bitmask: Equatable -
//

extension Bitmask: Equatable {}

public func == <T> (lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bool {
    return lhs.bitmaskValue == rhs.bitmaskValue
}



//
// MARK: - Bitmask: Comparable -
//

extension Bitmask: Comparable {}

public func < <T> (lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bool {
    return lhs.bitmaskValue < rhs.bitmaskValue
}



//
// MARK: - Bitmask: NilLiteralConvertible -
//

extension Bitmask: NilLiteralConvertible
{
    public init(nilLiteral: ())
    {
        self.init(BitmaskRawType.allZeros)
    }
}



//
// MARK: - Bitmask: BooleanType -
//

extension Bitmask: BooleanType
{
    /** For bitmasks, `boolValue` is `true` as long as any bit is set. */
    public var boolValue: Bool { return !isAllZeros }
}



//
// MARK: - Operators -
// MARK: - Quick instantiation prefix operator
//

prefix operator | {}

public prefix func | <T: IBitmaskRepresentable> (val:T) -> Bitmask<T> {
    return Bitmask<T>(val)
}



//
// MARK: - Bitwise OR
//

public func | <T: IBitmaskRepresentable> (lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bitmask<T> { return Bitmask(lhs.bitmaskValue | rhs.bitmaskValue) }
public func | <T: IBitmaskRepresentable> (lhs:Bitmask<T>, rhs:T)          -> Bitmask<T> { return Bitmask(lhs.bitmaskValue | rhs.bitmaskValue) }
public func | <T: IBitmaskRepresentable> (lhs:T, rhs:Bitmask<T>)          -> Bitmask<T> { return rhs | lhs }
public func | <T: IBitmaskRepresentable> (lhs:T, rhs:T)                   -> Bitmask<T> { return Bitmask(lhs.bitmaskValue | rhs.bitmaskValue) }

public func |= <T: IBitmaskRepresentable> (inout lhs:Bitmask<T>, rhs:T)          { lhs.setValue(lhs.bitmaskValue | rhs.bitmaskValue) }
public func |= <T: IBitmaskRepresentable> (inout lhs:Bitmask<T>, rhs:Bitmask<T>) { lhs.setValue(lhs.bitmaskValue | rhs.bitmaskValue) }



//
// MARK: - Bitwise AND
//

public func & <T: IBitmaskRepresentable> (lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bitmask<T> { return Bitmask(lhs.bitmaskValue & rhs.bitmaskValue) }
public func & <T: IBitmaskRepresentable> (lhs:Bitmask<T>, rhs:T)          -> Bitmask<T> { return Bitmask(lhs.bitmaskValue & rhs.bitmaskValue) }
public func & <T: IBitmaskRepresentable> (lhs:T,          rhs:Bitmask<T>) -> Bitmask<T> { return rhs & lhs }
public func & <T: IBitmaskRepresentable> (lhs:T, rhs:T)                   -> Bitmask<T> { return Bitmask(lhs.bitmaskValue & rhs.bitmaskValue) }

public func &= <T: IBitmaskRepresentable> (inout lhs:Bitmask<T>, rhs:T)          { lhs.setValue(lhs.bitmaskValue & rhs.bitmaskValue) }
public func &= <T: IBitmaskRepresentable> (inout lhs:Bitmask<T>, rhs:Bitmask<T>) { lhs.setValue(lhs.bitmaskValue & rhs.bitmaskValue) }



//
// MARK: - Bitwise XOR
//

public func ^ <T: IBitmaskRepresentable> (lhs:Bitmask<T>, rhs:Bitmask<T>) -> Bitmask<T> { return Bitmask(lhs.bitmaskValue ^ rhs.bitmaskValue) }
public func ^ <T: IBitmaskRepresentable> (lhs:Bitmask<T>, rhs:T)          -> Bitmask<T> { return Bitmask(lhs.bitmaskValue ^ rhs.bitmaskValue) }
public func ^ <T: IBitmaskRepresentable> (lhs:T, rhs:Bitmask<T>)          -> Bitmask<T> { return rhs ^ lhs }
public func ^ <T: IBitmaskRepresentable> (lhs:T, rhs:T)                   -> Bitmask<T> { return Bitmask(lhs.bitmaskValue ^ rhs.bitmaskValue) }

public func ^= <T: IBitmaskRepresentable> (inout lhs:Bitmask<T>, rhs:T)          { lhs.setValue(lhs.bitmaskValue ^ rhs.bitmaskValue) }
public func ^= <T: IBitmaskRepresentable> (inout lhs:Bitmask<T>, rhs:Bitmask<T>) { lhs.setValue(lhs.bitmaskValue ^ rhs.bitmaskValue) }



//
// MARK: - Bitwise NOT
//

public prefix func ~ <T: IBitmaskRepresentable> (value:Bitmask<T>) -> Bitmask<T> { return Bitmask(~(value.bitmaskValue)) }
public prefix func ~ <T: IBitmaskRepresentable> (value:T)          -> Bitmask<T> { return Bitmask(~(value.bitmaskValue)) }



//
// MARK: - Pattern matching operator
//

public func ~=<T: IBitmaskRepresentable> (pattern: Bitmask<T>, value: Bitmask<T>) -> Bool { return (pattern & value).boolValue }
public func ~=<T: IBitmaskRepresentable> (pattern: Bitmask<T>, value: T) -> Bool          { return (pattern & value).boolValue }
public func ~=<T: IBitmaskRepresentable> (pattern: T, value: Bitmask<T>) -> Bool          { return (pattern & value).boolValue }



//
// MARK: - Built-in type conformance to IBitmaskRawType
//

extension Int: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: Int { return self }
}
extension Int8: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: Int8 { return self }
}
extension Int16: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: Int16 { return self }
}
extension Int32: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: Int32 { return self }
}
extension Int64: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: Int64 { return self }
}
extension UInt: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: UInt { return self }
}
extension UInt8: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: UInt8 { return self }
}
extension UInt16: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: UInt16 { return self }
}
extension UInt32: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: UInt32 { return self }
}
extension UInt64: IBitmaskRepresentable, IBitmaskRawType {
    public var bitmaskValue: UInt64 { return self }
}








