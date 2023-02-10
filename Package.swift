// swift-tools-version:5.7

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
        //dev .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "2.2.0")),
        //dev .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "8.0.7")),
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.6.0")),
        .package(url: "https://github.com/philprime/Rainbow", .upToNextMajor(from: "0.0.4"))
    ],
    targets: [
        .target(name: "CoolDownParser"),
        //dev .testTarget(name: "CoolDownParserTests", dependencies: [
        //dev     "CoolDownParser",
        //dev     "Quick",
        //dev     "Nimble"
        //dev ]),
        .target(name: "CoolDownAttributedString", dependencies: [
            "CoolDownParser"
        ]),
        //dev .testTarget(name: "CoolDownAttributedStringTests", dependencies: [
        //dev     "CoolDownAttributedString",
        //dev     "Quick",
        //dev     "Nimble"
        //dev ]),
        .target(name: "CoolDownUIMapper", dependencies: [
            "CoolDownParser"
        ]),
        //dev .testTarget(name: "CoolDownUIMapperTests", dependencies: [
        //dev     "CoolDownUIMapper",
        //dev     "Quick",
        //dev     "Nimble"
        //dev ]),
        .target(name: "CoolDownSwiftUIMapper", dependencies: [
            "CoolDownParser",
            "Kingfisher",
            "Rainbow",
        ])
    ]
)
