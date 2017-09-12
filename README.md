
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftLinter.svg?maxAge=2592000)](http://cocoadocs.org/docsets/SwiftLinter)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/muyexi/SwiftLinter/blob/master/LICENSE)

Lint changed files with [SwiftLint](https://github.com/realm/SwiftLint).

## Installation

```
pod 'SwiftLinter'
```

## Usage
Add a new "Run Script Phase" with:

```
"${SRCROOT}/Pods/SwiftLinter/swift-lint.sh"
```

Configure SwiftLint by adding a `.swiftlint.yml` file to your project root directory. Learn more from [here](https://github.com/realm/SwiftLint#configuration). 

## License

SwiftLinter is released under the MIT license. See LICENSE for details.
