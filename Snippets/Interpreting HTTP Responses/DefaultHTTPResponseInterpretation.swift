// Throw an error if the HTTP response represents a failure.

// snippet.hide

import HTTPErrorHandling
import HTTPTypes

let request = HTTPRequest(method: .get,
                          scheme: "https",
                          authority: "example.com",
                          path: "/")

// snippet.show

let response = try await perform(request)
try response.throwIfFailed()

// snippet.hide

func perform(_ request: HTTPRequest) async throws -> HTTPResponse {
   return HTTPResponse(status: .ok)
}
