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
    typealias BitmaskRawType : BitwiseOperationsType, Equatable
    var bitmaskValue : BitmaskRawType { get }
}

public protocol IBitmaskInitializable
{
    typealias BitmaskRawType : BitwiseOperationsType, Equatable
    init(bitmaskValue:BitmaskRawType)
}


public struct Bitmask<R : BitwiseOperationsType where R : Equatable> : BitwiseOperationsType
{
    public typealias BitmaskRawType = R

    public private(set) var bitmaskValue : R = R.allZeros

    public static var allZeros : Bitmask<R> { return Bitmask(R.allZeros) }
    public var isAllZeros : Bool { return self.bitmaskValue == R.allZeros }

    public init() {}
    public init(bitmaskValue v: R)              { setValue(v) }
    public init(_ val: [R])                     { setValue(val) }
    public init(_ val: R...)                    { setValue(val) }
    public init(_ val: Bitmask<R>...)           { setValue(val) }

    public mutating func setValue(val: R) {
        bitmaskValue = val
    }

    public mutating func setValue(val:[R]) {
        let logicallyORed = val.reduce(R.allZeros) { $0 | $1 }
        setValue(logicallyORed)
    }

    public mutating func setValue(val:[Bitmask<R>]) {
        setValue(val.map { $0.bitmaskValue })
    }
}



extension Bitmask : IBitmaskRepresentable
{
    public init<U : IBitmaskRepresentable>(_ vals: [U]) {
        let arr = map(vals) { $0.bitmaskValue as R }
        self.init(arr)
    }
}








//public func logicalOr<T : IBitmaskRepresentable>(vals:[T]) -> T.BitmaskRawType
//{
//    let bitmaskValues : [T.BitmaskRawType] = vals |> mapSome({ $0.bitmaskValue })
//    let logicallyORed : T.BitmaskRawType = bitmaskValues.reduce(T.BitmaskRawType.allZeros) { $0 | $1 }
//
//    return logicallyORed ?? T.BitmaskRawType.allZeros
//}





//
// MARK: - Bitmask : Equatable -
//

extension Bitmask : Equatable {}

public func == <R : Equatable>(lhs:Bitmask<R>, rhs:Bitmask<R>) -> Bool {
    return lhs.bitmaskValue == rhs.bitmaskValue
}

//public func == <T : IBitmaskRepresentable where T.BitmaskRawType : Equatable>(lhs:T, rhs:T) -> Bool {
//    return lhs.bitmaskValue == rhs.bitmaskValue
//}



//
// MARK: - Operators -
// MARK: - Bitwise OR
//

public func | <R : Equatable where R : BitwiseOperationsType>(lhs:Bitmask<R>, rhs:Bitmask<R>) -> Bitmask<R> {
    return Bitmask(lhs.bitmaskValue | rhs.bitmaskValue)
}

public func | <R : Equatable where R : BitwiseOperationsType>(lhs:Bitmask<R>, rhs:R) -> Bitmask<R> {
    return Bitmask(lhs.bitmaskValue | rhs)
}

public func | <R : Equatable where R : BitwiseOperationsType>(lhs:R, rhs:Bitmask<R>) -> Bitmask<R> {
    return rhs | lhs
}



public func | <T : IBitmaskRepresentable>(lhs:T, rhs:T) -> Bitmask<T.BitmaskRawType> {
    return Bitmask(lhs.bitmaskValue | rhs.bitmaskValue)
}

public func | <T : IBitmaskRepresentable>(lhs:Bitmask<T.BitmaskRawType>, rhs:T) -> Bitmask<T.BitmaskRawType> {
    return Bitmask(lhs.bitmaskValue | rhs.bitmaskValue)
}

public func | <T : IBitmaskRepresentable>(lhs:T, rhs:Bitmask<T.BitmaskRawType>) -> Bitmask<T.BitmaskRawType> {
    return rhs | lhs
}



public func |= <R : Equatable where R : BitwiseOperationsType>(inout lhs:Bitmask<R>, rhs:R) {
    lhs.setValue(lhs.bitmaskValue | rhs)
}

public func |= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T.BitmaskRawType>, rhs:T) {
    lhs.setValue(lhs.bitmaskValue | rhs.bitmaskValue)
}

public func |= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T.BitmaskRawType>, rhs:Bitmask<T.BitmaskRawType>) {
    lhs.setValue(lhs.bitmaskValue | rhs.bitmaskValue)
}


//
// MARK: - Bitwise AND
//

public func & <R : Equatable where R : BitwiseOperationsType>(lhs:Bitmask<R>, rhs:Bitmask<R>) -> Bitmask<R> {
    return Bitmask(lhs.bitmaskValue & rhs.bitmaskValue)
}

public func & <R : Equatable where R : BitwiseOperationsType>(lhs:Bitmask<R>, rhs:R) -> Bitmask<R> {
    return Bitmask(lhs.bitmaskValue & rhs)
}

public func & <R : Equatable where R : BitwiseOperationsType>(lhs:R, rhs:Bitmask<R>) -> Bitmask<R> {
    return rhs & lhs
}



public func & <T : IBitmaskRepresentable>(lhs:T, rhs:T) -> Bitmask<T.BitmaskRawType> {
    return Bitmask(lhs.bitmaskValue & rhs.bitmaskValue)
}

public func & <T : IBitmaskRepresentable>(lhs:Bitmask<T.BitmaskRawType>, rhs:T) -> Bitmask<T.BitmaskRawType> {
    return Bitmask(lhs.bitmaskValue & rhs.bitmaskValue)
}

public func & <T : IBitmaskRepresentable>(lhs:T, rhs:Bitmask<T.BitmaskRawType>) -> Bitmask<T.BitmaskRawType> {
    return rhs & lhs
}



public func &= <R : Equatable where R : BitwiseOperationsType>(inout lhs:Bitmask<R>, rhs:R) {
    lhs.setValue(lhs.bitmaskValue & rhs)
}

public func &= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T.BitmaskRawType>, rhs:T) {
    lhs.setValue(lhs.bitmaskValue & rhs.bitmaskValue)
}

public func &= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T.BitmaskRawType>, rhs:Bitmask<T.BitmaskRawType>) {
    lhs.setValue(lhs.bitmaskValue & rhs.bitmaskValue)
}


//
// MARK: - Bitwise XOR
//

public func ^ <T : IBitmaskRepresentable>(lhs:T, rhs:T) -> Bitmask<T.BitmaskRawType> {
    return Bitmask(lhs.bitmaskValue ^ rhs.bitmaskValue)
}

public func ^ <R : Equatable where R : BitwiseOperationsType>(lhs:Bitmask<R>, rhs:Bitmask<R>) -> Bitmask<R> {
    return Bitmask(lhs.bitmaskValue ^ rhs.bitmaskValue)
}

public func ^ <T : IBitmaskRepresentable>(lhs:Bitmask<T.BitmaskRawType>, rhs:T) -> Bitmask<T.BitmaskRawType> {
    return Bitmask(lhs.bitmaskValue ^ rhs.bitmaskValue)
}

public func ^ <T : IBitmaskRepresentable>(lhs:T, rhs:Bitmask<T.BitmaskRawType>) -> Bitmask<T.BitmaskRawType> {
    return rhs ^ lhs
}

public func ^= <R : Equatable where R : BitwiseOperationsType>(inout lhs:Bitmask<R>, rhs:R) {
    lhs.setValue(lhs.bitmaskValue ^ rhs)
}

public func ^= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T.BitmaskRawType>, rhs:T) {
    lhs.setValue(lhs.bitmaskValue ^ rhs.bitmaskValue)
}

public func ^= <T : IBitmaskRepresentable>(inout lhs:Bitmask<T.BitmaskRawType>, rhs:Bitmask<T.BitmaskRawType>) {
    lhs.setValue(lhs.bitmaskValue ^ rhs.bitmaskValue)
}


//
// MARK: - Bitwise NOT
//

public prefix func ~ <R : BitwiseOperationsType where R : Equatable>(value:Bitmask<R>) -> Bitmask<R> {
    return Bitmask(~value.bitmaskValue)
}

public prefix func ~ <T : IBitmaskRepresentable>(value:T) -> Bitmask<T.BitmaskRawType> {
    return Bitmask(~value.bitmaskValue)
}



//
// MARK: - Pattern matching operator
//

public func ~=<R : BitwiseOperationsType where R : Equatable>(pattern:Bitmask<R>, value:Bitmask<R>) -> Bool {
    return (pattern & value).isAllZeros == false
}

public func ~=<R : BitwiseOperationsType where R : Equatable>(pattern:Bitmask<R>, value:R) -> Bool {
    return (pattern & value).isAllZeros == false
}

public func ~=<R : BitwiseOperationsType where R : Equatable>(pattern:R, value:Bitmask<R>) -> Bool {
    return (pattern & value).isAllZeros == false
}


public func ~=<T : IBitmaskRepresentable>(pattern: Bitmask<T.BitmaskRawType>, value: Bitmask<T.BitmaskRawType>) -> Bool {
    return (pattern & value).isAllZeros == false
}

public func ~=<T : IBitmaskRepresentable>(pattern: Bitmask<T.BitmaskRawType>, value: T) -> Bool {
    return (pattern & value).isAllZeros == false
}

public func ~=<T : IBitmaskRepresentable>(pattern: T, value: Bitmask<T.BitmaskRawType>) -> Bool {
    return (pattern & value).isAllZeros == false
}


