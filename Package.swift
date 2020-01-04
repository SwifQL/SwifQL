// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwifQL",
    products: [
        // Swift lib that gives ability to build complex raw SQL-queries in strong-type declarative way
        .library(name: "SwifQL", targets: ["SwifQL"]),
        ],
    dependencies: [],
    targets: [
        .target(name: "SwifQL", dependencies: []),
        .testTarget(name: "SwifQLTests", dependencies: ["SwifQL"]),
        ],
    swiftLanguageVersions: [.v4_2]
)
