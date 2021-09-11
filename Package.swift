// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CoolDown",
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(name: "CoolDown", targets: ["CoolDownParser"]),
        .library(name: "CoolDownAttributedString", targets: ["CoolDownAttributedString"]),
        .library(name: "CoolDownUIMapper", targets: ["CoolDownUIMapper"]),
        .library(name: "CoolDownSwiftUIMapper", targets: ["CoolDownSwiftUIMapper"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "2.2.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "8.0.7")),
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(name: "CoolDownParser"),
        .testTarget(name: "CoolDownParserTests", dependencies: [
            "CoolDownParser",
            "Quick",
            "Nimble"
        ]),
        .target(name: "CoolDownAttributedString", dependencies: [
            "CoolDownParser"
        ]),
        .testTarget(name: "CoolDownAttributedStringTests", dependencies: [
            "CoolDownAttributedString",
            "Quick",
            "Nimble"
        ]),
        .target(name: "CoolDownUIMapper", dependencies: [
            "CoolDownParser"
        ]),
        .testTarget(name: "CoolDownUIMapperTests", dependencies: [
            "CoolDownUIMapper",
            "Quick",
            "Nimble"
        ]),
        .target(name: "CoolDownSwiftUIMapper", dependencies: [
            "CoolDownParser",
            "Kingfisher"
        ])
    ]
)
