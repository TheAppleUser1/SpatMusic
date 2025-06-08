// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SpatMusicApp",
    platforms: [.iOS(.v15)],
    products: [
        .executable(name: "SpatMusicApp", targets: ["SpatMusicApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/madmachiney/MusicKit", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "SpatMusicApp",
            dependencies: ["MusicKit"],
            path: "Sources/SpatMusicApp")
    ]
)
