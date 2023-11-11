## MyCLI

Follow these steps to build MyCLI

- https://www.swift.org/getting-started/cli-swiftpm/
  Build a Command-line Tool

- https://github.com/apple/swift-package-manager
  - https://github.com/apple/swift-package-manager/blob/main/Documentation/README.md
  - https://github.com/apple/swift-package-manager/blob/main/Documentation/Usage.md

```

cd .../MyCLI
swift run MyCLI --input 'Hello, world!'
swift build -c release


swift package init --name ExtractFlags --type executable
swift run ExtractFlags


```
