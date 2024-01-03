// Customize the interpretation of the HTTP response status.

// snippet.hide

import HTTPErrorHandling
import HTTPTypes

let request = HTTPRequest(method: .post,
                          scheme: "https",
                          authority: "example.com",
                          path: "/")

// snippet.show

let response = try await perform(request)
try response.throwIfFailed(
   successStatuses: [.created],
   transientFailureStatuses: HTTPResponse.Status.transientFailures.union([.conflict])
)

// snippet.hide

func perform(_ request: HTTPRequest) async throws -> HTTPResponse {
   return HTTPResponse(status: .ok)
}
