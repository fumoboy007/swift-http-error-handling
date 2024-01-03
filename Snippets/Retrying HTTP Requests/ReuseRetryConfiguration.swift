// Encapsulate retry behavior in a ``RetryConfiguration`` instance.

// snippet.hide

import HTTPErrorHandling
import HTTPTypes
import Logging
import Retry

let request = HTTPRequest(method: .get,
                          scheme: "https",
                          authority: "example.com",
                          path: "/")

// snippet.show

extension RetryConfiguration<ContinuousClock> {
   static let standard = RetryConfiguration()

   static let highTolerance = (
      Self.standard
         .withMaxAttempts(10)
         .withBackoff(.default(baseDelay: .seconds(1),
                               maxDelay: nil))
   )
}

try await request.retry(with: .highTolerance.withLogger(myLogger)) { request in
   let response = try await perform(request)
   try response.throwIfFailed()
}

// snippet.hide

let myLogger = Logger(label: "Example Code")

func perform(_ request: HTTPRequest) async throws -> HTTPResponse {
   return HTTPResponse(status: .ok)
}
