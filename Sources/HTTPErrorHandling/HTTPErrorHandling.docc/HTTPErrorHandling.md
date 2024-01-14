# ``HTTPErrorHandling``

Interpret HTTP responses and handle failures.

## Overview

In the HTTP protocol, a client sends a request to a server and the server sends a response back to the client. The response contains a [status code](https://httpwg.org/specs/rfc9110.html#overview.of.status.codes) to help the client interpret the response.

HTTP libraries like `Foundation` pass the response through to the caller without interpreting the response as a success or failure. `HTTPErrorHandling` can help the caller interpret HTTP responses and handle failures.

The module works with any HTTP library that is compatible with Swift’s [standard HTTP request and response types](https://github.com/apple/swift-http-types). The module can be used on its own in code that directly uses an HTTP library, or the module can be used as a building block by higher-level networking libraries.

### Representing an HTTP Application Failure

After interpreting an HTTP response as a success or a failure, there needs to be a way to represent a failure. In Swift, failures are represented by a type that conforms to the `Error` protocol. Therefore, the module exposes an ``HTTPApplicationError`` type to represent a failure.

### Interpreting HTTP Responses

The module extends `HTTPResponse` with a ``HTTPTypes/HTTPResponse/throwIfFailed(successStatuses:transientFailureStatuses:)`` method that interprets the response as a success or failure. The method throws ``HTTPApplicationError`` if the response is interpreted as a failure.

Some HTTP servers add additional details about a failure to the response body. The ``HTTPTypes/HTTPResponse/throwIfFailed(successStatuses:transientFailureStatuses:makeResponseBody:)`` method allows for the response body to be deserialized and attached to the error so that the additional failure details can be accessed later.

### Retrying HTTP Requests

The module extends `HTTPRequest` to add conformance to [`RetryableRequest`](https://fumoboy007.github.io/swift-retry/documentation/retry/retryablerequest), which is a protocol from the [`swift-retry`](https://swiftpackageindex.com/fumoboy007/swift-retry) package that adds safe retry methods to the type. The safe retry methods enforce that the HTTP request is [idempotent](https://httpwg.org/specs/rfc9110.html#idempotent.methods).

The retry method implementations automatically choose a [`RecoveryAction`](https://fumoboy007.github.io/swift-retry/documentation/retry/recoveryaction) for ``HTTPApplicationError`` using HTTP-specific information including whether the failure is transient and the value of the [`Retry-After`](https://httpwg.org/specs/rfc9110.html#field.retry-after) header, if present.

## Topics

### Examples

- <doc:Examples-of-Interpreting-HTTP-Responses>
- <doc:Examples-of-Retrying-HTTP-Requests>
- <doc:Examples-of-Interoperability-With-Popular-HTTP-Libraries>

### Representing an HTTP Application Failure

- ``HTTPApplicationError``
- ``HTTPApplicationErrorProtocol``

### Interpreting HTTP Responses

- ``HTTPTypes/HTTPResponse``
- ``HTTPTypes/HTTPResponse/Status``

### Retrying HTTP Requests

- ``HTTPTypes/HTTPRequest``
