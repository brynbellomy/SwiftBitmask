//
//  Functions.Strings.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 8.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Regex


//
// MARK: - String functions
//

/**
    Converts its argument to a `String`.
 */
public func stringify <T> (something:T) -> String {
    return "\(something)"
}


/**
    Splits the input string at every newline and returns the array of lines.
 */
public func lines (str:String) -> [String] {
    return str |> splitOn("\n")
}


/**
    Convenience function that calls `Swift.dump(value, &x)` and returns `x`.
 */
public func dumpString<T>(value:T) -> String {
    var msg = ""
    dump(value, &msg)
    return msg
}


/**
    Pads the end of a string to the given length with the given padding string.

    :param: string The input string to pad.
    :param: length The length to which the string should be padded.
    :param: padding The string to use as padding.
    :returns: The padded `String`.
 */
public func pad (string:String, length:Int, #padding:String) -> String {
    return string.stringByPaddingToLength(length, withString:padding, startingAtIndex:0)
}

/**
    Pads the beginning of a string to the given length with the given padding string.

    :param: string The input string to pad.
    :param: length The length to which the string should be padded.
    :param: padding The string to use as padding.
    :returns: The padded `String`.
 */
public func padFront (string:String, length:Int, #padding:String) -> String
{
    let disparity = length - count(string)
    if disparity <= 0 {
        return string
    }
    let padding = Array(count: disparity, repeatedValue: Character(padding))
    return String(padding) + string
}


/**
    Pads a string to the given length using a space as the padding character.

    :param: string The input string to pad.
    :param: length The length to which the string should be padded.
    :returns: The padded `String`.
 */
public func pad (string:String, length:Int) -> String {
    return string.stringByPaddingToLength(length, withString:" ", startingAtIndex:0)
}


/**
    Pads the strings in `strings` to the same length using a space as the padding character.

    :param: strings The array of strings to pad.
    :returns: An array containing the padded `String`s.
 */
public func padToSameLength <S: SequenceType where S.Generator.Element == String> (strings:S) -> [S.Generator.Element]
{
    let maxLength = strings |> map‡ (count)
                            |> maxElement

    return strings |> map‡ (pad‡ (maxLength))
}


/**
    Pads the `String` keys of `strings` to the same length using a space as the padding
    character.  This is mainly useful as a console output formatting utility.

    :param: dict The dictionary whose keys should be padded.
    :returns: A new dictionary with padded keys.
 */
public func padKeysToSameLength <V> (dict: [String: V]) -> [String: V]
{
    let maxLength = dict |> map‡ (takeLeft >>> count)
                         |> maxElement

    return dict |> mapKeys(pad‡ (maxLength))
}


/**
    Returns the substring in `string` from `index` to the last character.
 */
public func substringFromIndex (index:Int) (string:String) -> String
{
    let newStart = advance(string.startIndex, index)
    return string[newStart ..< string.endIndex]
}



/**
    Returns the substring in `string` from the first character to `index`.
 */
public func substringToIndex (index:Int) (string:String) -> String
{
    let newEnd = advance(string.startIndex, index)
    return string[string.startIndex ..< newEnd]
}


/**
    Returns a string containing a pretty-printed representation of `array`.
 */
public func describe <T> (array:[T]) -> String
{
    return describe(array) { stringify($0) }
}


/**
    Returns a string containing a pretty-printed representation of `array` created
    by mapping `formatElement` over its elements.
 */
public func describe <T> (array:[T], formatElement:(T) -> String) -> String
{
    return array |> map‡ (formatElement >>> indent)
                 |> joinWith(",\n")
                 |> { "[\n\($0)\n]" }
}


/**
    Returns a string containing a pretty-printed representation of `dict`.
 */
public func describe <K, V> (dict:[K: V]) -> String
{
    func renderKeyValue(key:String, value:V) -> String { return "\(key)  \(value)," }

    return dict |> mapKeys { "\($0):" }
                |> padKeysToSameLength
                |> map‡ (renderKeyValue >>> indent)
                |> joinWith("\n")
                |> { "{\n\($0)\n}" }
}


/**
    Returns a string containing a pretty-printed representation of `dict` created
    by mapping `formatClosure` over its elements.
 */
public func describe <K, V> (dict:[K: V], formatClosure:(K, V) -> String) -> String
{
    return dict |> map‡ (formatClosure)
                |> map‡ (indent)
                |> joinWith(",\n")
                |> { "{\n\($0)\n}" }
}


/**
    Splits `string` into lines, adds four spaces to the beginning of each line, and
    then joins the lines into a single string again (preserving the original newlines).
 */
public func indent(string:String) -> String
{
    let spaces = "    "
    return string |> splitOn("\n")
                  |> map‡   { "\(spaces)\($0)" }
                  |> joinWith("\n")
}


/**
    Removes whitespace (including newlines) from the beginning and end of `str`.
 */
public func trim(str:String) -> String {
    return str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
}

public func trimToLength (string:String, length:Int) -> String {
    return count(string) <= length
                ? string
                : (string |> substringToIndex(length))
}


/**
    Generates an rgba tuple from a hex color string.

    :param: hex The hex color string from which to create the color object.  '#' sign is optional.
 */
public func rgbaFromHexCode(hex:String) -> (r:UInt32, g:UInt32, b:UInt32, a:UInt32)?
{
    let sanitized = hex.replaceRegex("[^a-fA-F0-9]", with: "")
    
    let strLen = count(sanitized)
    if strLen != 6 && strLen != 8 {
        return nil
    }

    let groups: [String] = (sanitized =~ Regex("([:xdigit:][:xdigit:])")).captures |> toArray
    if groups.count < 3 {
        return nil
    }

    let (red, green, blue) = (readHexInt(groups[0]), readHexInt(groups[1]), readHexInt(groups[2]))
    var alpha: UInt32?
    if groups.count >= 4 {
        alpha = readHexInt(groups[3])
    }

    if let (r, g, b) = all(red, green, blue)
    {
        if let a = alpha {
            return (r:r, g:g, b:b, a:a)
        }
        else {
            return (r:r, g:g, b:b, a:255)
        }

    }
    return nil
}


/**
    Given a palette of `n` colors and a tuple `(r, g, b, a)` of `UInt32`s, this function
    will return a tuple (r/n, g/n, b/n, a/n)
 */
public func normalizeRGBA (colors c:UInt32) (r:UInt32, g:UInt32, b:UInt32, a:UInt32) -> (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
    return (r:CGFloat(r/c), g:CGFloat(g/c), b:CGFloat(b/c), a:CGFloat(a/c))
}


/**
    Attempts to interpret `str` as a hexadecimal integer.  If this succeeds, the integer
    is returned as a `UInt32`.
 */
public func readHexInt (str:String) -> UInt32? {
    var i: UInt32 = 0
    let success = NSScanner(string:str).scanHexInt(&i)
    return success ? i : nil
}


/**
    Attempts to interpret `string` as an rgba string of the form: `rgba(1.0, 0.2, 0.3, 0.4)`.  
    The values are interpreted as `CGFloat`s from `0.0` to `1.0`.
 */
public func rgbaFromRGBAString (string:String) -> (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)?
{
    let sanitized = (string =~ Regex("[^0-9,\\.]")) |> map‡ ("") 
    
    let parts: [CGFloat?] = sanitized |> splitOn(",")
                                      |> map‡ (trim)
                                      |> map‡ { $0.toCGFloat() }
    if parts.count != 4 {
        return nil
    }
    else if let (red, green, blue, alpha) = all(parts[0], parts[1], parts[2], parts[3]) {
        return (r:red, g:green, b:blue, a:alpha)
    }

    return nil
}


private extension String
{
    func toCGFloat() -> CGFloat? {
        return CGFloat((self as NSString).floatValue)
    }
}




