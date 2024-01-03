// MIT License
//
// Copyright © 2024 Darren Mo.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import HTTPTypes

/// Adds methods to interpret the response and throw ``HTTPApplicationError`` if the response
/// represents an application failure.
extension HTTPResponse {
   /// Throws ``HTTPApplicationError`` if the response represents an application failure.
   ///
   /// - Parameters:
   ///    - successStatuses: The HTTP response statuses that indicate success.
   ///    - transientFailuresStatuses: The HTTP response statuses that indicate the failure is transient.
   ///       If the failure is transient, a subsequent attempt may succeed. If the failure is not transient, subsequent
   ///       attempts will never succeed.
   ///
   /// - SeeAlso: ``throwIfFailed(successStatuses:transientFailureStatuses:makeResponseBody:)``
   public func throwIfFailed(
      successStatuses: Set<Status> = HTTPResponse.Status.successes,
      transientFailureStatuses: Set<Status> = HTTPResponse.Status.transientFailures
   ) throws {
      precondition(successStatuses.isDisjoint(with: transientFailureStatuses))

      guard successStatuses.contains(status) else {
         let isTransientFailure = transientFailureStatuses.contains(status)

         throw HTTPApplicationError(response: self,
                                    responseBody: (),
                                    isTransient: isTransientFailure)
      }
   }

   /// Throws ``HTTPApplicationError`` if the response represents an application failure. The error instance
   /// includes the response body.
   ///
   /// - Parameters:
   ///    - successStatuses: The HTTP response statuses that indicate success.
   ///    - transientFailuresStatuses: The HTTP response statuses that indicate the failure is transient.
   ///       If the failure is transient, a subsequent attempt may succeed. If the failure is not transient, subsequent
   ///       attempts will never succeed.
   ///    - makeResponseBody: A closure that returns the response body, which can be accessed via
   ///       ``HTTPApplicationError/responseBody``. The closure is `async` because the response
   ///       body may not yet have been fully received.
   ///
   /// - SeeAlso: ``throwIfFailed(successStatuses:transientFailureStatuses:)``
   public func throwIfFailed<ResponseBodyType>(
      successStatuses: Set<Status> = HTTPResponse.Status.successes,
      transientFailureStatuses: Set<Status> = HTTPResponse.Status.transientFailures,
      @_inheritActorContext @_implicitSelfCapture makeResponseBody: () async throws -> ResponseBodyType
   ) async throws {
      precondition(successStatuses.isDisjoint(with: transientFailureStatuses))

      guard successStatuses.contains(status) else {
         let responseBody = try await makeResponseBody()

         let isTransientFailure = transientFailureStatuses.contains(status)

         throw HTTPApplicationError(response: self,
                                    responseBody: responseBody,
                                    isTransient: isTransientFailure)
      }
   }
}
