//
//  AutoBitmask.swift
//  SwiftBitmask
//
//  Created by bryn austin bellomy on 2014 Nov 5.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


public protocol IAutoBitmaskable : Equatable
{
    class var autoBitmaskValues : [Self] { get }
}


/**
 * The functions in AutoBitmask offer a simple technique allowing non-bitwise types
 * to conform to IBitmaskRepresentable with only a few lines of code.  Types must
 * conform to IAutoBitmaskable (which inherits from IBitmaskRepresentable). Enums
 * seem to work best.
 */
public struct AutoBitmask
{
    public static func autoBitmaskValueFor <T : protocol<IAutoBitmaskable, IBitmaskRepresentable>> (autoBitmaskable:T) -> T.BitmaskRawType
    {
        if let index = find(T.autoBitmaskValues, autoBitmaskable)? {
            return T.BitmaskRawType(1 << index)
        }
        else { preconditionFailure("Attempted to call autoBitmaskValueFor(_:) with a non-bitmaskable value of T.") }
    }


    public static func autoValueFromBitmask <T : protocol<IAutoBitmaskable, IBitmaskRepresentable>> (bitmaskValue:T.BitmaskRawType) -> T
    {
        let index = findWhere(T.autoBitmaskValues) { $0.bitmaskValue == bitmaskValue }
        if let index = index {
            return T.autoBitmaskValues[index]
        }
        else { preconditionFailure("Attempted to call autoBitmaskValueFor(_:) with a non-bitmaskable value of T.") }
    }
}



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






