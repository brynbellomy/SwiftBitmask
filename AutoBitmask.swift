//
//  AutoBitmask.swift
//  SwiftBitmask
//
//  Created by bryn austin bellomy on 2014 Nov 5.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation

/**
 * The functions in AutoBitmask offer a simple technique allowing non-bitwise types
 * to conform to IBitmaskRepresentable with only a few lines of code.  Types must
 * conform to IAutoBitmaskable (which inherits from IBitmaskRepresentable). Enums
 * seem to work best.
 */


public protocol IAutoBitmaskable : IBitmaskRepresentable, Equatable {
    class var autoBitmaskValues : [Self] { get }
}


public protocol IAutoBitmaskRawType : BitwiseOperationsType, Equatable {
    init(_ v:Int)
}


extension Bitmask
{
    public static func autoBitmaskValueFor
      < AutoBitmaskType : IAutoBitmaskable where
        AutoBitmaskType : Equatable,
        AutoBitmaskType.BitmaskRawType : IAutoBitmaskRawType >
        (bitmaskable:AutoBitmaskType) -> AutoBitmaskType.BitmaskRawType
    {
        if let index = find(AutoBitmaskType.autoBitmaskValues, bitmaskable)? {
            return AutoBitmaskType.BitmaskRawType(1 << index)
        }
        else { preconditionFailure("Attempted to call autoBitmaskValueFor(_:) with a non-bitmaskable value of AutoBitmaskType.") }
    }


    public static func autoValueFromBitmask
      < AutoBitmaskType : IAutoBitmaskable where
        AutoBitmaskType : Equatable,
        AutoBitmaskType.BitmaskRawType : IAutoBitmaskRawType >
        (inout you:AutoBitmaskType, bitmaskValue:AutoBitmaskType.BitmaskRawType)
    {
        let index = findWhere(AutoBitmaskType.autoBitmaskValues) { $0.bitmaskValue == bitmaskValue }
        if let index = index {
            you = AutoBitmaskType.autoBitmaskValues[index]
        }
        else { preconditionFailure("Attempted to call autoBitmaskValueFor(_:) with a non-bitmaskable value of AutoBitmaskType.") }
    }
}


extension Int    : IAutoBitmaskRawType {}
extension Int8   : IAutoBitmaskRawType {}
extension Int16  : IAutoBitmaskRawType {}
extension Int32  : IAutoBitmaskRawType {}
extension Int64  : IAutoBitmaskRawType {}
extension UInt   : IAutoBitmaskRawType {}
extension UInt8  : IAutoBitmaskRawType {}
extension UInt16 : IAutoBitmaskRawType {}
extension UInt32 : IAutoBitmaskRawType {}
extension UInt64 : IAutoBitmaskRawType {}




private func findWhere<C : CollectionType where C.Generator.Element : Equatable>(domain: C, predicate: (C.Generator.Element) -> Bool) -> C.Index?
{
    var maybeIndex : C.Index? = domain.startIndex
    do
    {
        if let index = maybeIndex?
        {
            let item = domain[index]
            if predicate(item) == true {
                return index
            }

            maybeIndex = index.successor()
        }

    } while maybeIndex != nil

    return nil
}





