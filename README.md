

# how

Here's a quick example of a type that implements the `IBitmaskRepresentable` protocol, which is pretty helpful for facilitating the use of `Bitmask` with other types.

```swift
enum SimpleOptions : UInt16, IBitmaskRepresentable
{
    case One = 1
    case Two = 2
    case Three = 4

    var bitmaskValue : BitmaskRawType { return self.rawValue }

    init(bitmaskValue: UInt16) { self.init(rawValue:bitmaskValue) }
}
```

Once you do that, you can do this:

```swift
func exampleUsage()
{
    func simpleOptions()
    {
        // example: SimpleOptions
        let option : SimpleOptions = .Two
        let orWithVar = option | .One

        let simpleOr  = SimpleOptions.One | .Two
        let orValue   = (SimpleOptions.One | .Two).bitmaskValue

        switch simpleOr {
            case SimpleOptions.One.bitmaskValue:    println("one")
            case Bitmask<UInt16>.allZeros:          println("all zeros")
            default:                                println("not one")
        }
    }
}
```


# automatic bitmask raw values

You can also have your `Bitmask` object generate the bitmask values for your `IBitmaskRepresentable` type.  This is useful if, say, your type is an enum with a non-integer raw type.

For example, let's say you're reading options out of a JSON config file and they're represented as an array of strings.  This approach allows you to write your `enum` type concisely (in other words, you don't have to implement `var bitmaskValue` with a big `switch` statement).  Just add a `class var autoBitmaskValues : [Self]` and implement `var bitmaskValue` and `init(bitmaskValue:T)` with the auto-bitmasking functions like so:


```swift
enum ExampleAutoOptions : IAutoBitmaskable
{
    case None
    case One
    case Two

    static var autoBitmaskValues : [ExampleAutoOptions] = [.None, .One, .Two,]

    var bitmaskValue : UInt16 { return Bitmask<UInt16>.autoBitmaskValueFor(self) }

    init(bitmaskValue: UInt16) {
        self = .None
        Bitmask<UInt16>.autoValueFromBitmask(&self, bitmaskValue:bitmaskValue)
    }
}


func exampleUsage()
{
    func simpleOptions()
    {
        // example: AutoOptions
        let option : ExampleAutoOptions = .Two
        let orWithVar = option | .One

        let simpleOr  = ExampleAutoOptions.One | .Two
        let orValue   = (ExampleAutoOptions.One | .Two).bitmaskValue

        switch simpleOr {
            case ExampleAutoOptions.One.bitmaskValue:   println("one")
            case Bitmask<UInt16>.allZeros:              println("all zeros")
            default:                                    println("not one")
        }
    }
}

```

The values in the `autoBitmaskValues` array are assigned integer bitmask values (i.e., `1 << 0`, `1 << 1`, ... `1 << n`) from left to right.


# license

WTFPL


# authors / contributors

bryn bellomy < <bryn.bellomy@gmail.com> >

