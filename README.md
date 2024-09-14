# AUnitViews

AUnitViews is a Swift package that provides a set of SwiftUI views for binding and displaying numeric values with selectable units. It supports various input and display modes, allowing users to either input a value or view its converted equivalent with the associated unit. This package leverages [AUnit](https://github.com/RapboyGao/AUnit.git) and [AViewUI](https://github.com/RapboyGao/AViewUI.git) to handle unit conversion and custom UI components.

## Features

- Bind numeric values with selectable units in a user-friendly manner.
- SwiftUI-based components supporting macOS, iOS, and tvOS.
- Customizable views to support various unit types and formats.
- Includes components for both input and display of unit-converted values.
- Unit type conversions, easy selectors, and flexible view options.

## Requirements

- Swift 5.10 or later
- iOS 16.0+, macOS 12.0+, tvOS 15.0+
- Dependencies:
  - [AUnit](https://github.com/RapboyGao/AUnit.git)
  - [AViewUI](https://github.com/RapboyGao/AViewUI.git)

## Installation

To use AUnitViews in your project, add it as a dependency in your `Package.swift` file:

```swift
// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "YourProjectName",
    dependencies: [
        .package(url: "https://github.com/RapboyGao/AUnitViews.git", branch: "main")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["AUnitViews"]
        ),
    ]
)
```

Then run:

```bash
swift package update
```

## Usage

### AUnitBindNumberViews

AUnitBindNumberViews is a SwiftUI view for binding and displaying a numeric value with a selectable unit. It supports input and display modes, allowing the user to either input a value or simply view its converted equivalent with its unit.

```swift
AUnitBindNumberViews(
    value: .constant(nil),
    unit: .constant(.meters),
    origin: .meters,
    digits: 5,
    placeholder: "Enter value",
    allowInput: true
)
```

### AUnitInputViews

AUnitInputViews is used for inputting a value and selecting a unit. It automatically handles unit conversion and updates the bound value.

```swift
AUnitInputViews(
    value: .constant(1500),
    unit: .constant(.feet),
    originalUnit: .meters,
    digits: 5,
    placeholder: "Input value"
)
```

### AUnitTypeConversionsAppView

AUnitTypeConversionsAppView displays a list of all unit types and allows users to navigate through different units for conversion.

```swift
NavigationView {
    AUnitTypeConversionsAppView()
        .navigationTitle("Units")
}
```

## Localization

The package supports localization for unit names and other UI elements. The default localization is set to English.

## Contribution

Feel free to contribute to the project by submitting pull requests or reporting issues. Make sure to follow the project's code of conduct.

## License

AUnitViews is released under the MIT License. See [LICENSE](LICENSE) for details.
