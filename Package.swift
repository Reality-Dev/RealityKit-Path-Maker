// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

import PackageDescription

let package = Package(
  name: "RKPath",
  platforms: [.iOS("13.0")],
  products: [
    .library(name: "RKPath", targets: ["RKPath"])
  ],
  dependencies: [],
  targets: [
    .target(name: "RKPath", dependencies: [])
  ],
  swiftLanguageVersions: [.v5]
)

