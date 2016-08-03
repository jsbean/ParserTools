# ArrayTools

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/dn-m/ArrayTools.svg?branch=master)](https://travis-ci.org/dn-m/ArrayTools)

Extensions of Swift Array struct

***

<a name="integration"></a>
## Integration

### Carthage
Integrate **ArrayTools** into your OSX or iOS project with [Carthage](https://github.com/Carthage/Carthage).

1. Follow [these instructions](https://github.com/Carthage/Carthage#installing-carthage) to install Carthage, if necessary.
2. Add `github "dn-m/ArrayTools"` to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile) 
3. Follow [these instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to integrate **ArrayTools** into your OSX or iOS project.

***

## Usage

### List Processing

#### Destructure an `Array` into `head` and `tail`
```Swift
let emptyArray = []
let (head, tail) = emptyArray.destructured // nil
```

```Swift
let array = [1,2,3]
let (head, tail) = array.destructured // (1, [2,3])
```

#### Construct an `Array` from a `head` and `tail`
```Swift
let head = 5
let tail = [10,15]
let list = head + tail  // [5,10,15]
```
