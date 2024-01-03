// Configure the retry behavior.

// snippet.hide

import HTTPErrorHandling
import HTTPTypes
import Logging

let request = HTTPRequest(method: .get,
                          scheme: "https",
                          authority: "example.com",
                          path: "/")

// snippet.show

try await request.retry(maxAttempts: 5,
                        backoff: .default(baseDelay: .milliseconds(500),
                                          maxDelay: .seconds(10)),
                        logger: myLogger) { request in
   let response = try await perform(request)
   try response.throwIfFailed()
}

// snippet.hide

let myLogger = Logger(label: "Example Code")

func perform(_ request: HTTPRequest) async throws -> HTTPResponse {
   return HTTPResponse(status: .ok)
}
