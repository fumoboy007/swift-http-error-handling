// Retry an HTTP request using `URLSession`.

// snippet.hide

#if canImport(Darwin)

// snippet.show

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

// snippet.hide

print(responseBody)

#endif
