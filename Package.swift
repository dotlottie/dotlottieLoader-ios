// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "dotLottieLoader",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_12),
        .tvOS(.v9),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "dotLottieLoader",
            targets: ["dotLottieLoader"]),
    ],
    dependencies: [
        .package(name: "Zip", url: "https://github.com/marmelroy/Zip.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "dotLottieLoader",
            dependencies: ["Zip"]),
        .testTarget(
            name: "dotLottieLoaderTests",
            dependencies: ["dotLottieLoader"]),
    ]
)
