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
import Retry

/// Adds `RetryableRequest` conformance to `HTTPRequest`.
///
/// The `RetryableRequest` conformance adds safe retry methods to `HTTPRequest`.
///
/// - Important: The retry methods accept a closure that attempts the request. The closure must interpret the response
///    and throw ``HTTPApplicationError`` when the response represents a failure. Calling
///    ``HTTPTypes/HTTPResponse/throwIfFailed(successStatuses:transientFailureStatuses:)``
///    is a convenient way to do so.
///
/// The `recoverFromFailure` closure is not called when the failure is due to ``HTTPApplicationError``. The
/// retry method implementations automatically choose a recovery action for ``HTTPApplicationError`` using
/// HTTP-specific information including whether the error is transient and the value of the `Retry-After` header,
/// if present.
///
/// - SeeAlso: [`Retry`](https://fumoboy007.github.io/swift-retry/documentation/retry/)
extension HTTPRequest: RetryableRequest {
   public var isIdempotent: Bool {
      return method.isIdempotent
   }

   public func unsafeRetryIgnoringIdempotency<ClockType, ReturnType>(
      with configuration: RetryConfiguration<ClockType>,
      @_inheritActorContext @_implicitSelfCapture operation: (Self) async throws -> ReturnType
   ) async throws -> ReturnType {
      let configuration = configuration.withRecoverFromFailure { error in
         switch error {
         case let error as any HTTPApplicationErrorProtocol:
            return RecoveryAction(error, clock: configuration.clock)

         default:
            return configuration.recoverFromFailure(error)
         }
      }

      return try await Retry.retry(with: configuration) {
         return try await operation(self)
      }
   }
}
