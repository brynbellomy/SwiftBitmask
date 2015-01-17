
# a replacement for NS_OPTIONS / RawOptionSet

`Bitmask<T>` is a quicker way to get `NS_OPTIONS`-style functionality in a Swift environment.  It's intended a replacement for Swift's `RawOptionSet`, which is so long and arduous to implement that [someone wrote a code generator for it](http://natecook.com/blog/2014/07/swift-options-bitmask-generator/).

It allows you to use the simple, familiar syntax of Swift's bitwise operators (`|`, `&`, `~`, `^`, etc.) with any custom `struct`, `enum`, or `class` type by wrapping that type in a `Bitmask<T>`.


# Bitmask&lt;T&gt; with raw integer types

The `Bitmask` class takes a generic parameter indicating the type of integer you want to use to store the bitmask's raw value.  Code:

```swift
let bitmask = Bitmask<UInt16>(1 << 2 | 1 << 5)
bitmask.bitmaskValue  // returns UInt16(1 << 2 | 1 << 5)
```

```swift
let bitmaskA = Bitmask<UInt16>(1 << 2)
let bitmaskB = Bitmask<UInt16>(1 << 5)
let allTogetherNow = bitmaskA | bitmaskB
bitmask.bitmaskValue  // also returns UInt16(1 << 2 | 1 << 5), just like above
```


# Bitmask&lt;T&gt; with any type

Bitmasks can be converted back and forth between non-integer types as well.  Any type implementing the `IBitmaskRepresentable` protocol gets this functionality for free.

All the protocol requires is that you implement `var bitmaskValue`, ensuring that its type conforms to `BitwiseOperationsType` and `Equatable`:

```swift
public protocol IBitmaskRepresentable
{
    typealias BitmaskRawType : BitwiseOperationsType, Equatable
    var bitmaskValue : BitmaskRawType { get }
}
```

Just use any built-in integer type and it'll work.

Here's a quick example of a type that implements `IBitmaskRepresentable`:

```swift
enum MonsterAttributes : UInt16, IBitmaskRepresentable
{
    case Big = 1
    case Ugly = 2
    case Scary = 4

    var bitmaskValue : BitmaskRawType { return self.rawValue }

    init(bitmaskValue: UInt16) {
        self.init(rawValue:bitmaskValue)
    }
}
```

Now you can create a `Bitmask<MonsterAttributes>` and use it the same way you would use a `Bitmask` with a raw integer underlying type:

```swift
let b = Bitmask<MonsterAttributes>(.Big, .Scary)
```


# what does this get me?

## concise syntax

You can write code that's almost as concise as the syntax you would use for simple, integral bitwise operations, but with the improved type safety and versatility of doing so with your own custom type.  **Note that you almost never have to write Bitmask&lt;T&gt;**:

```swift
// prefix operator initialization
let bitmask = |MonsterAttributes.Scary         // == Bitmask(MonsterAttributes.Scary)

// implicit initialization via bitwise operators
let option : MonsterAttributes = .Ugly
let orWithVar = option | .Big                 // == Bitmask<UInt16> with a bitmaskValue of 1 | 2
let simpleOr  = MonsterAttributes.Big | .Ugly // == Bitmask<UInt16> with a bitmaskValue of 1 | 2

// the raw bitmask value can be obtained with from the bitmaskValue property
let simpleOrValue = simpleOr.bitmaskValue                        // == UInt16(1 | 2)
let orValue       = (MonsterAttributes.Big | .Ugly).bitmaskValue // == UInt16(1 | 2)
```

## if statements

`Bitmask` also implements `NilLiteralConvertible` and `BooleanType`, which allow for concise conditionals:

```swift
// Bitmask<T> implements BooleanType
if simpleOr & MonsterAttributes.Scary {
    println("(boolean comparison) scary!")
}

// Bitmask<T> implements NilLiteralConvertible
if simpleOr & MonsterAttributes.Scary != nil {
    println("(nil literal comparison) scary!")
}
```


## pattern matching + switch

`Bitmask` can tango with the pattern-matching operator (`~=`), which is basically equivalent to checking if bits are set using `&`:

```swift
// Bitmask<T> is compatible with ~=, the pattern-matching operator
if simpleOr ~= MonsterAttributes.Scary {
    println("(pattern matching operator) scary!")
}

if simpleOr ~= MonsterAttributes.Scary | .Big {
    println("(pattern matching operator) either big or scary!")
}
```


You can write switch statements with `Bitmask` too, although in my experience playing around with this code so far, it almost never seems to be the control structure that makes the most sense.  If you insist upon trying it out, just be careful to add `fallthrough`s where appropriate and put your `case` statements in an order that makes sense for your application:

```swift
switch simpleOr
{
    case |MonsterAttributes.Big:
        println("big!")
        fallthrough

    case MonsterAttributes.Big | .Scary:
        println("either big or scary!")
        fallthrough

    case |MonsterAttributes.Ugly:
        println("ugly!")
        fallthrough

    case |MonsterAttributes.Scary:
        println("scary!")
        fallthrough

    default:
        // ...
}
```


# automatic bitmask raw values for the lazy and overworked

You can also have your `Bitmask` object auto-generate the bitmask values for your `IBitmaskRepresentable` type.  This is useful if, say, your type is an `enum` with a non-integer raw type.

For example, let's say you're reading options out of a JSON config file and they're represented as an array of strings, and you want your `enum`'s `rawValue`s to represent what's in the file.  By implementing `IAutoBitmaskable`, you can use a couple of convenience functions in your type's implementation of `IBitmaskRepresentable` and escape having to write a big `switch` statement that doubles the length of your type's code.

Just conform to `IAutoBitmaskable` and add `class/static var autoBitmaskValues : [Self]`, which should return all of the values of your `enum`.  You can then implement `var bitmaskValue` and `init(bitmaskValue:T)` with the auto-bitmasking functions like so:


```swift
enum MonsterAttributes : String, IBitmaskRepresentable, IAutoBitmaskable
{
    case Big = "big"
    case Ugly = "ugly"
    case Scary = "scary"

    static var autoBitmaskValues : [MonsterAttributes] = [.Big, .Ugly, .Scary,]

    var  bitmaskValue: UInt16  { return AutoBitmask.autoBitmaskValueFor(self) }
    init(bitmaskValue: UInt16) { self = AutoBitmask.autoValueFromBitmask(bitmaskValue) }
}
```


If you're curious, the values in the `autoBitmaskValues` array are assigned integer bitmask values (i.e., `1 << 0`, `1 << 1`, ... `1 << n`) from left to right.


# a few implementation details

It's worth noting that because Bitmask<T> stores its raw value as a basic `BitwiseOperationsType` (in other words, an integer of some kind), its memory footprint is incredibly small, especially compared with an implementation that basically functions as a wrapper over a `Set` (or some other collection type).  This is particularly nice when you're using bitmasks to initialize or configure a huge number of objects at the same time.

The trade-off, of course, is that any time you convert values back and forth between your `IBitmaskRepresentable` type and `Bitmask`, it incurs some processing overhead in accessing your object's `bitmaskValue` property (and, if you implemented `IAutoBitmaskable`, there's an array search operation involved as well — take a look at [AutoBitmask.swift](https://github.com/brynbellomy/SwiftBitmask/blob/master/AutoBitmask.swift) if you're concerned about that).

I chose this implementation because I'm using `Bitmask` to initialize values during a load phase of a game I'm working on.  Since the actual `Bitmask` objects are out of the picture as soon as loading is complete, there's very little back-and-forth between my `IBitmaskRepresentable` types and `Bitmask`, meaning there's not much processing overhead for me.  I just hold onto the integer values, which is what the game engine wants anywway.

However, if you have a use case that would benefit from implementing `Bitmask` as a collection wrapper, I'd be interested in hearing about it in the [issue queue](https://github.com/brynbellomy/SwiftBitmask/issues)!


# license

WTFPL


# authors / contributors

bryn bellomy < <bryn.bellomy@gmail.com> >



