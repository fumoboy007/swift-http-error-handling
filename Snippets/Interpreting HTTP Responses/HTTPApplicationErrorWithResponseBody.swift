// Attach the response body to ``HTTPApplicationError`` and access it later.

// snippet.hide

import Foundation
import HTTPErrorHandling
import HTTPTypes

let request = HTTPRequest(method: .get,
                          scheme: "https",
                          authority: "example.com",
                          path: "/")

// snippet.show

do {
   let (responseBody, response) = try await perform(request)
   try await response.throwIfFailed {
      return try await deserializeFailureDetails(from: responseBody)
   }
} catch let error as HTTPApplicationError<MyFailureDetails> {
   let failureDetails = error.responseBody
   doSomething(with: failureDetails)
}

// snippet.hide

func perform(_ request: HTTPRequest) async throws -> (Data, HTTPResponse) {
   return (Data(), HTTPResponse(status: .ok))
}

struct MyFailureDetails {
}

func deserializeFailureDetails(from responseBody: Data) async throws -> MyFailureDetails {
   return MyFailureDetails()
}

func doSomething(with failureDetails: MyFailureDetails) {
}
