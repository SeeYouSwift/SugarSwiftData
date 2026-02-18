// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SugarSwiftData",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "SugarSwiftData", targets: ["SugarSwiftData"]),
        .library(name: "SugarSwiftDataMocks", targets: ["SugarSwiftDataMocks"])
    ],
    targets: [
        .target(name: "SugarSwiftData"),
        .target(name: "SugarSwiftDataMocks", dependencies: ["SugarSwiftData"]),
        .testTarget(name: "SugarSwiftDataTests", dependencies: ["SugarSwiftData"])
    ]
)
