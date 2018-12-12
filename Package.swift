// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwifQL",
    products: [
        // Swift lib that gives ability to build complex raw SQL-queries in a more easy way using KeyPaths
        .library(name: "SwifQL", targets: ["SwifQL"]),
        .library(name: "SwifQLPure", targets: ["SwifQL", "SwifQLPure"]),
        .library(name: "SwifQLVapor", targets: ["SwifQL", "SwifQLVapor"]),
        ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.10.0"),
        .package(url: "https://github.com/vapor/core.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/postgresql.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/mysql.git", from: "3.0.0"),
        ],
    targets: [
        .target(name: "SwifQL", dependencies: []),
        .target(name: "SwifQLPure", dependencies: ["NIO", "SwifQL"]),
        .target(name: "SwifQLVapor", dependencies: ["NIO", "Core", "SwifQL", "MySQL", "PostgreSQL"]),
        .testTarget(name: "SwifQLTests", dependencies: ["SwifQL", "SwifQLPure"]),
        ],
    swiftLanguageVersions: [.v4_2]
)
