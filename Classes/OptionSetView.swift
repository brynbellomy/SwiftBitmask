//
//  OptionSetView.swift
//  SwiftBitmask
//
//  Created by bryn austin bellomy on 2015 Feb 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


public struct OptionSetView <T: IBitmaskRepresentable>
{
    let bitmask: Bitmask<T>
    public init(bitmask b: Bitmask<T>) {
        bitmask = b
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

//extension OptionSetView: SequenceType
//{
//    public typealias Generator = GeneratorOf<T>
//    public func generate() -> Generator
//    {
//        
//        var generator = elements.generate()
//        return GeneratorOf {
//            return generator.next()?.item
//        }
//    }
//}
