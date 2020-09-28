// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CoolDown",
    products: [
        .library(name: "CoolDown", targets: ["CDASTParser"]),
        .library(name: "CoolDownAttributedString", targets: ["CDAttributedString"]),
        .library(name: "CoolDownUIMapper", targets: ["CDUIMapper"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "2.2.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "8.0.7"))
    ],
    targets: [
        .target(name: "CDASTParser"),
        .testTarget(name: "CDASTParserTests", dependencies: [
            "CDASTParser",
            "Quick",
            "Nimble"
        ]),
        .target(name: "CDAttributedString", dependencies: [
            "CDASTParser"
        ]),
        .testTarget(name: "CDAttributedStringTests", dependencies: [
            "CDAttributedString",
            "Quick",
            "Nimble"
        ]),
        .target(name: "CDUIMapper", dependencies: [
            "CDASTParser"
        ]),
        .testTarget(name: "CDUIMapperTests", dependencies: [
            "CDUIMapper",
            "Quick",
            "Nimble"
        ]),
    ]
)
