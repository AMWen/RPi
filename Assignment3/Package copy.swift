// swift-tools-version:5.0
import PackageDescription

let deps: [Package.Dependency] = [
        .package(url: "https://github.com/ComputeCycles/GATT", .branch("swift5")),
        .package(url: "https://github.com/ComputeCycles/BluetoothLinux", .branch("swift5")),
        .package(url: "https://github.com/ComputeCycles/Bluetooth", .branch("swift5"))
	]
let targetDeps: [Target.Dependency] = ["GATT", "BluetoothLinux"]

let package = Package(
    name: "Assignment4",
    products: [
        .executable(
            name: "e16server",
            targets: ["e16server"]
        )
    ],
    dependencies: deps,
    targets: [
        .target(
            name: "e16server",
            dependencies: targetDeps
        )
    ]
)
