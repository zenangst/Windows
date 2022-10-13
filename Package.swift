// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Windows",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "Windows", targets: ["Windows"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
          name: "Windows"
        ),
        .testTarget(
          name: "WindowsTests",
          dependencies: ["Windows"])
    ]
)

