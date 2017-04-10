//
//  OptionSetView.swift
//  SwiftBitmask
//
//  Created by bryn austin bellomy on 2015 Feb 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


///
/// Curried version of the `OptionSetView` constructor.
///  
/// For example: `bitmask |> asOptionSet([.First, .Second, .Third])`
///
public func asOptionSet <T: IBitmaskRepresentable where T: Hashable>
    (possibleOptions:Set<T>) (bitmask:Bitmask<T>) -> OptionSetView<T>
{
    return OptionSetView(bitmask:bitmask, possibleOptions:possibleOptions)
}


/**
    A representation of a finite set of options (or flags), some of which are set (flagged).
    A `Bitmask<T>` can be converted to an `OptionSetView<T>`.
 */
public struct OptionSetView <T: IBitmaskRepresentable where T: Hashable>
{
    let bitmask: Bitmask<T>
    let possibleOptions: Set<T>
    let options: Set<T>
    
    public init(bitmask b: Bitmask<T>, possibleOptions po:Set<T>)
    {
        bitmask = b
        possibleOptions = po
        
        options = Set(possibleOptions.filter { b.isSet($0) })
    }

    public func isSet(option:T) -> Bool {
        return (bitmask & option).bitmaskValue == option.bitmaskValue
    }

    public func areSet(options:T...) -> Bool {
        let otherBitmask = Bitmask(options)
        return (bitmask & otherBitmask).bitmaskValue == otherBitmask.bitmaskValue
    }
}

//
// MARK: - OptionSetView: SequenceType
//

extension OptionSetView: SequenceType
{
    public func generate() -> AnyGenerator<T> {
        var generator = options.generate()
        return anyGenerator { generator.next() }
    }
}
