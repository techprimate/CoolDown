// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CoolDown",
    products: [
        .library(name: "CoolDown", targets: ["CDASTParser", "CDAttributedString"])
    ],
    dependencies: [

    ],
    targets: [
        .target(name: "CDASTParser", dependencies: []),
        .target(name: "CDAttributedString", dependencies: []),
        .testTarget(name: "CDASTParserTests", dependencies: ["CDASTParser"]),
    ]
)
