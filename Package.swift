// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CoolDown",
    products: [
        .library(name: "CoolDown", targets: ["CDASTParser", "CDAttributedString"])
    ],
    dependencies: [
        .package(url: "https://github.com/philprime/Stencil", .upToNextMajor(from: "0.0.1")),
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "2.2.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "8.0.7"))
    ],
    targets: [
        .target(name: "CDASTParser", dependencies: [
            "Stencil"
        ]),
        .target(name: "CDAttributedString", dependencies: []),
        .testTarget(name: "CDASTParserTests", dependencies: [
            "CDASTParser",
            "Quick",
            "Nimble"
        ]),
    ]
)
