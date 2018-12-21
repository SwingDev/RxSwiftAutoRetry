// swift-tools-version:4.2
//
//  Package.swift
//  Test
//
//  Created by Krystian Bujak on 12/12/2018.
//  Copyright © 2018 SwingDev. All rights reserved.
//
import PackageDescription

let package = Package(
    name: "RxSwiftAutoRetry",
    products: [
        .library(name: "RxSwiftAutoRetry", targets: ["RxSwiftAutoRetry"]),
        ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("4.4.0")),
        ],
    targets: [
        .target(
            name: "RxSwiftAutoRetry",
            dependencies: ["RxSwift"],
            path: "Source"
        )
    ]
)
