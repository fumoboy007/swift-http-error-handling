# swift-http-error-handling

Interpret HTTP responses and handle failures in Swift.

![Swift 5.9](https://img.shields.io/badge/swift-v5.9-%23F05138)
![Linux, visionOS 1, macOS 13, iOS 16, tvOS 16, watchOS 9](https://img.shields.io/badge/platform-Linux%20%7C%20visionOS%201%20%7C%20macOS%2013%20%7C%20iOS%2016%20%7C%20tvOS%2016%20%7C%20watchOS%209-blue)
![MIT License](https://img.shields.io/github/license/fumoboy007/swift-http-error-handling)
![Automated Tests Workflow Status](https://img.shields.io/github/actions/workflow/status/fumoboy007/swift-http-error-handling/tests.yml?event=push&label=tests)

## Overview

In the HTTP protocol, a client sends a request to a server and the server sends a response back to the client. The response contains a [status code](https://httpwg.org/specs/rfc9110.html#overview.of.status.codes) to help the client interpret the response.

HTTP libraries like `Foundation` pass the response through to the caller without interpreting the response as a success or failure. `HTTPErrorHandling` can help the caller interpret HTTP responses and handle failures.

The module works with any HTTP library that is compatible with Swift’s [standard HTTP request and response types](https://github.com/apple/swift-http-types). The module can be used on its own in code that directly uses an HTTP library, or the module can be used as a building block by higher-level networking libraries.

### Representing an HTTP Application Failure

After interpreting an HTTP response as a success or a failure, there needs to be a way to represent a failure. In Swift, failures are represented by a type that conforms to the `Error` protocol. Therefore, the module exposes an `HTTPApplicationError` type to represent a failure.

### Interpreting HTTP Responses

The module extends `HTTPResponse` with a `throwIfFailed` method that interprets the response as a success or failure. The method throws `HTTPApplicationError` if the response is interpreted as a failure.

Some HTTP servers add additional details about a failure to the response body. The `throwIfFailed` method allows for the response body to be deserialized and attached to the error so that the additional failure details can be accessed later.

### Retrying HTTP Requests

The module extends `HTTPRequest` to add conformance to [`RetryableRequest`](https://fumoboy007.github.io/swift-retry/documentation/retry/retryablerequest), which is a protocol from the [`swift-retry`](https://swiftpackageindex.com/fumoboy007/swift-retry) package that adds safe retry methods to the type. The safe retry methods enforce that the HTTP request is [idempotent](https://httpwg.org/specs/rfc9110.html#idempotent.methods).

The retry method implementations automatically choose a [`RecoveryAction`](https://fumoboy007.github.io/swift-retry/documentation/retry/recoveryaction) for `HTTPApplicationError` using HTTP-specific information including whether the failure is transient and the value of the [`Retry-After`](https://httpwg.org/specs/rfc9110.html#field.retry-after) header, if present.

## Example Usage With `URLSession`

```swift
import Foundation
import HTTPErrorHandling
import HTTPTypes
import HTTPTypesFoundation

let request = HTTPRequest(method: .get,
                          scheme: "https",
                          authority: "example.com",
                          path: "/")

let responseBody = try await request.retry { request in
   let (responseBody, response) = try await URLSession.shared.data(for: request)
   try response.throwIfFailed()
   return responseBody
}
```

See the [documentation](https://fumoboy007.github.io/swift-http-error-handling/documentation/httperrorhandling/) for more examples.
