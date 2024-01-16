// swift-tools-version: 5.9

import PackageDescription

let package = Package(
   name: "swift-http-error-handling",
   platforms: [
      .visionOS(.v1),
      .macOS(.v13),
      .macCatalyst(.v16),
      .iOS(.v16),
      .tvOS(.v16),
      .watchOS(.v9),
   ],
   products: [
      .library(
         name: "HTTPErrorHandling",
         targets: [
            "HTTPErrorHandling",
         ]
      ),
      // According to SE-0356, Swift Package Manager does not yet officially support snippet-only dependencies.
      // This library product and the corresponding target work around that limitation. The product name is
      // prefixed with an underscore to convey that the product was not meant to be externally visible.
      .library(
         name: "_AdditionalHTTPErrorHandlingSnippetDependencies",
         targets: [
            "_AdditionalHTTPErrorHandlingSnippetDependencies",
         ]
      ),
   ],
   dependencies: [
      .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.3.0"),
      .package(url: "https://github.com/apple/swift-http-types.git", from: "1.0.2"),
      .package(url: "https://github.com/apple/swift-log.git", from: "1.5.3"),
      .package(url: "https://github.com/fumoboy007/swift-retry.git", .upToNextMinor(from: "0.2.2")),
   ],
   targets: [
      .target(
         name: "HTTPErrorHandling",
         dependencies: [
            .product(name: "DMRetry", package: "swift-retry"),
            .product(name: "HTTPTypes", package: "swift-http-types"),
         ]
      ),
      .testTarget(
         name: "HTTPErrorHandlingTests",
         dependencies: [
            "HTTPErrorHandling",
            .product(name: "HTTPTypes", package: "swift-http-types"),
         ]
      ),
      .target(
         name: "_AdditionalHTTPErrorHandlingSnippetDependencies",
         dependencies: [
            .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
            .product(name: "Logging", package: "swift-log"),
         ]
      ),
   ]
)
