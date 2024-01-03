# ``HTTPErrorHandling``

Interpret HTTP responses and handle failures.

## Overview

In the HTTP protocol, a client sends a request to a server and the server sends a response back to the client. The response contains a [status code](https://httpwg.org/specs/rfc9110.html#overview.of.status.codes) to help the client interpret the response.

HTTP libraries like `Foundation` pass the response through to the caller without interpreting the response as a success or failure. `HTTPErrorHandling` can help the caller interpret HTTP responses and handle failures.

The module works with any HTTP library that is compatible with Swift’s [standard HTTP request and response types](https://github.com/apple/swift-http-types). The module can be used on its own in code that directly uses an HTTP library, or the module can be used as a building block by higher-level networking libraries.

## Topics

### Examples

- <doc:Interpreting-HTTP-Responses>
- <doc:Retrying-HTTP-Requests>
- <doc:Interoperability-With-Popular-HTTP-Libraries>

### Representing an HTTP Application Failure

- ``HTTPApplicationError``
- ``HTTPApplicationErrorProtocol``

### Interpreting HTTP Responses

- ``HTTPTypes/HTTPResponse``
- ``HTTPTypes/HTTPResponse/Status``

### Retrying HTTP Requests

- ``HTTPTypes/HTTPRequest``
