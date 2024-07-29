// swift-tools-version: 5.10

///
import PackageDescription


///
let package = Package(
    name: "LeakTracker-package",
    platforms: [.macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(
            name: "LeakTracker-module",
            targets: ["LeakTracker-module"]
        ),
    ],
    dependencies: [],
    targets: [
        
        ///
        .target(
            name: "LeakTracker-module",
            dependencies: []
        ),
        
        ///
        .testTarget(
            name: "LeakTracker-module-tests",
            dependencies: ["LeakTracker-module"]
        ),
    ]
)
