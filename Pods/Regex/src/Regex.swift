//
//  SwiftRegex.swift
//  SwiftRegex
//
//  Created by bryn austin bellomy on 2/10/2015
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


public extension String
{
    /**
        Searches the receiving `String` with the regex given in `pattern`, returning the match results.
     */
    public func grep (pattern:String) -> Regex.MatchResult {
        return self =~ Regex(pattern)
    }

    /**
        Searches the receiving string with the regex given in `pattern`, replaces the match(es) with `replacement`, and returns the resulting string.
     */
    public func replaceRegex(pattern:String, with replacement:String) -> String {
        return map(self =~ Regex(pattern), replacement)
    }
}

public extension String
{
    var fullRange:   Range<String.Index> { return startIndex ..< endIndex }
    var fullNSRange: NSRange             { return NSRange(location:0, length:count(self)) }

    func substringWithRange (range:NSRange) -> String {
       return substringWithRange(convertRange(range))
    }

    func convertRange (range: Range<Int>) -> Range<String.Index> {
        let start = advance(self.startIndex, range.startIndex)
        let end   = advance(start, range.endIndex - range.startIndex)
        return Range(start: start, end: end)
    }

    func convertRange (nsrange:NSRange) -> Range<String.Index> {
        let start = advance(self.startIndex, nsrange.location)
        let end   = advance(start, nsrange.length)
        return Range(start: start, end: end)
    }
}


/**
    A `Regex` represents a compiled regular expression that can be applied to
    `String` objects to search for (and replace) matched patterns.
 */
public struct Regex
{
    public typealias MatchResult = RegexMatchResult

    private let pattern: String
    private let nsRegex: NSRegularExpression


    public static func create(pattern:String) -> (Regex?, NSError?)
    {
        var err: NSError?
        let regex = Regex(pattern: pattern, error: &err)

        if let err = err            { return (nil, err) }
        else if let regex = regex   { return (regex, nil) }
        else                        { return (nil, NSError(domain: "com.illumntr.Regex", code: 1, userInfo:[NSLocalizedDescriptionKey: "Unknown error."])) }
    }


    public init(_ p:String)
    {
        pattern = p

        var err: NSError?
        let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(0), error: &err)
        if let regex = regex {
            nsRegex = regex
        }
        else { fatalError("Invalid regex: \(p)") }
    }


    public init? (pattern p:String, error:NSErrorPointer)
    {
        pattern = p

        var err: NSError?
        let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(0), error: &err)
        if let regex = regex {
            nsRegex = regex
        }
        else {
            nsRegex = NSRegularExpression()
            if let err = err {
                error.memory = err
            }
            return nil
        }
    }


    public func match (string:String) -> MatchResult
    {
        var matches  = [NSTextCheckingResult]()
        let all      = NSRange(location: 0, length: count(string))
        let moptions = NSMatchingOptions(0)

        nsRegex.enumerateMatchesInString(string, options:moptions, range:all) {
            (result: NSTextCheckingResult!, flags: NSMatchingFlags, ptr: UnsafeMutablePointer<ObjCBool>) in
            if let result = result {
                matches.append(result)
            }
        }

        return MatchResult(regex:nsRegex, searchString:string, items: matches)
    }


    public func replaceMatchesIn (string:String, with replacement:String) -> (replacements:Int, string:String)
    {
        var mutableString = NSMutableString(string:string)
        let replacements  = nsRegex.replaceMatchesInString(mutableString, options:NSMatchingOptions(0), range:string.fullNSRange, withTemplate:replacement)

        return (replacements:replacements, string:String(mutableString))
    }


    public func replaceMatchesIn (string:String, with replacement:String) -> String {
        return map((string =~ self), replacement)
    }
}


infix operator =~ {}

/**
    Searches `searchString` using `regex` and returns the resulting `Regex.MatchResult`.
*/
public func =~ (searchString: String, regex:Regex) -> Regex.MatchResult {
    return regex.match(searchString)
}


/**
    An object representing the result of searching a given `String` using a `Regex`.
 */
public struct RegexMatchResult: SequenceType, BooleanType
{
    /** Returns `true` if the number of matches is greater than zero. */
    public var boolValue: Bool { return items.count > 0 }

    public let regex: NSRegularExpression
    public let searchString: String
    public let items: [NSTextCheckingResult]
    public let captures: [String]


    /**
        The designated initializer.

        :param: regex The `NSRegularExpression` that was used to create this `RegexMatchResult`.
        :param: searchString The string that was searched by `regex` to generate these results.
        :param: items The array of `NSTextCheckingResult`s generated by `regex` while searching `searchString`.
    */
    public init(regex r:NSRegularExpression, searchString s:String, items i:[NSTextCheckingResult])
    {
        regex = r
        searchString = s
        items = i

        captures = map(items) { result in s.substringWithRange(result.range) }
    }


    /**
        Returns the `i`th match as an `NSTextCheckingResult`.
     */
    subscript (i: Int) -> NSTextCheckingResult {
        get { return items[i] }
    }


    /**
        Returns the captured text of the `i`th match as a `String`.
     */
    subscript (i: Int) -> String {
        get { return captures[i] }
    }


    /**
        Returns a `Generator` that iterates over the captured matches as `NSTextCheckingResult`s.
     */
    public func generate() -> GeneratorOf<NSTextCheckingResult> {
        var gen = items.generate()
        return GeneratorOf { gen.next() }
    }


    /**
        Returns a `Generator` that iterates over the captured matches as `String`s.
     */
    public func generateCaptures() -> GeneratorOf<String> {
        var gen = captures.generate()
        return GeneratorOf { gen.next() }
    }
}


/**
    Returns the `String` created by replacing the regular expression matches in `regexResult` using `replacementTemplate`.
 */
public func map (regexResult:Regex.MatchResult, replacementTemplate:String) -> String
{
    let searchString = NSMutableString(string: regexResult.searchString)
    let fullRange    = regexResult.searchString.fullNSRange
    regexResult.regex.replaceMatchesInString(searchString, options: NSMatchingOptions(0), range:fullRange, withTemplate:replacementTemplate)
    return String(searchString)
}


