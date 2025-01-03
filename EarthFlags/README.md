# EarthFlags

## loading, saving, exporting and importing JSON

- Settings saved as JSON in local file documents directory

- LocationListView: Settings exporting and importing from the clip board

## kit integration

### WebKit integration

- FlagWebView
  - WebView : UIViewRepresentable
  - WKWebView

### MapKit integration

- MapTabView
  - https://github.com/molab-itp/09-Bucketlist
  - https://www.hackingwithswift.com/books/ios-swiftui/bucket-list-introduction
  - https://github.com/twostraws/HackingWithSwift.git

### SceneKit integration

- SwiftGloble
  - SwiftGlobeBridgeRep: UIViewControllerRepresentable
  - https://github.com/dmojdehi/SwiftGlobe.git
  - An interactive 3D globe in SceneKit for iOS, watchOS, tvOS, and MacOS X.

## asset preparation

### EarthFlags/EarthFlags/Resources/countries_capitals.json

- Country locations merged into country flag info

  - ExportFlagsApp/node/parseCountries.js

- EarthFlags/EarthFlags/Resources/countries.json
  - JSON for each country

### EarthFlags/EarthFlags/Assets.xcassets

- view flags stored as jpg in Assets.xcassets

- assets generated by ExportFlagsApp

  - SVG SwiftUI viewer
  - https://github.com/exyte/SVGView

- from svg and JSON
  - https://github.com/linssen/country-flag-icons/blob/master/countries.json
