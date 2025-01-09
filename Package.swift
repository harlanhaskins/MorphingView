// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MorphingView",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "MorphingView",
            targets: ["MorphingView"]),
    ],
    targets: [
        .target(
            name: "MorphingView"),
        .testTarget(
            name: "MorphingViewTests",
            dependencies: ["MorphingView"]
        ),
    ]
)
