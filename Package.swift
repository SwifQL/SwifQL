// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SwifQL",
    platforms: [
      .macOS(.v10_15), .iOS(.v12)
    ],
    products: [
        // 💎 Swift lib that gives an ability to build complex raw SQL-queries in strong-type declarative way
        .library(name: "SwifQL", targets: ["SwifQL"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SwifQL", dependencies: []),
        .testTarget(name: "SwifQLTests", dependencies: [.target(name: "SwifQL")]),
    ]
)
