
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftLinter.svg?maxAge=2592000)](http://cocoadocs.org/docsets/SwiftLinter)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/muyexi/SwiftLinter/blob/master/LICENSE)

SwiftLinter help you share lint rules between projects and lint changed Swift source files in your Git repo with [SwiftLint](https://github.com/realm/SwiftLint).

## Installation

```
pod 'SwiftLinter'
```

## Usage
Add a new "Run Script Phase" with:

```
"${SRCROOT}/Pods/SwiftLinter/swift-lint.sh"
```

Or specify ` autocorrect` to autocorrect changed files:
```
"${SRCROOT}/Pods/SwiftLinter/swift-lint.sh" autocorrect
```

To change the default rules, fork this repo and edit the config file based on your needs. Learn more from [here](https://github.com/realm/SwiftLint#configuration).

```
pod 'SwiftLinter', :git => 'YOUR_GIT_REPO'
```

## License

SwiftLinter is released under the MIT license. See LICENSE for details.
