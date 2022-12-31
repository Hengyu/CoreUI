// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10),
    ],
    products: [
        .library(name: "AutumnUI", targets: ["AutumnUI"]),
        .library(name: "SpringUI", targets: ["SpringUI"]),
    ],
    targets: [
        .target(name: "AutumnUI"),
        .target(name: "SpringUI", dependencies: ["AutumnUI"]),
        .testTarget(name: "CoreUITests", dependencies: ["AutumnUI"]),
    ]
)
