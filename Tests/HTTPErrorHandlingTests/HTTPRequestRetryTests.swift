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

import HTTPErrorHandling

import HTTPTypes
import XCTest

final class HTTPRequestRetryTests: XCTestCase {
   func testTransientHTTPApplicationError_isRetried() async throws {
      var attemptCount = 0

      try await HTTPRequest.fake.retry(clock: ClockFake()) { request in
         attemptCount += 1

         if attemptCount == 1 {
            throw HTTPApplicationError(response: .transientFailureFake,
                                       responseBody: (),
                                       isTransient: true)
         } else {
            // Success.
         }
      }

      XCTAssertEqual(attemptCount, 2)
   }

   func testTransientHTTPApplicationError_recoverFromFailureNotCalled() async throws {
      var attemptCount = 0

      try await HTTPRequest.fake.retry(clock: ClockFake()) { request in
         attemptCount += 1

         if attemptCount == 1 {
            throw HTTPApplicationError(response: .transientFailureFake,
                                       responseBody: (),
                                       isTransient: true)
         } else {
            // Success.
         }
      } recoverFromFailure: { error in
         XCTFail("`recoverFromFailure` should not be called when the error is `HTTPApplicationError`.")
         return .throw
      }

      XCTAssertEqual(attemptCount, 2)
   }

   func testNonTransientHTTPApplicationError_notRetried() async throws {
      var attemptCount = 0

      do {
         try await HTTPRequest.fake.retry(clock: ClockFake()) { request in
            attemptCount += 1

            if attemptCount == 1 {
               throw HTTPApplicationError(response: .nonTransientFailureFake,
                                          responseBody: (),
                                          isTransient: false)
            } else {
               // Success.
            }
         }
      } catch is HTTPApplicationError<Void> {
         // Expected.
      }

      XCTAssertEqual(attemptCount, 1)
   }

   func testNonTransientHTTPApplicationError_recoverFromFailureNotCalled() async throws {
      var attemptCount = 0

      do {
         try await HTTPRequest.fake.retry(clock: ClockFake()) { request in
            attemptCount += 1

            if attemptCount == 1 {
               throw HTTPApplicationError(response: .nonTransientFailureFake,
                                          responseBody: (),
                                          isTransient: false)
            } else {
               // Success.
            }
         } recoverFromFailure: { error in
            XCTFail("`recoverFromFailure` should not be called when the error is `HTTPApplicationError`.")
            return .retry
         }
      } catch is HTTPApplicationError<Void> {
         // Expected.
      }

      XCTAssertEqual(attemptCount, 1)
   }

   func testHTTPApplicationErrorWithRetryAfterValue_valueIsDate_sleepsAtLeastUntilDate() async throws {
      let clockFake = ClockFake()

      var attemptCount = 0

      try await HTTPRequest.fake.retry(maxAttempts: nil,
                                       clock: clockFake,
                                       backoff: .default(baseDelay: .seconds(1),
                                                         maxDelay: nil)) { request in
         attemptCount += 1

         if attemptCount == 1 {
            var failureResponse = HTTPResponse.transientFailureFake
            // Use a distant date that is practically guaranteed to never be reached.
            failureResponse.headerFields[.retryAfter] = "Wed, 07 Jan 3024 00:00:00 GMT"

            throw HTTPApplicationError(response: failureResponse,
                                       responseBody: (),
                                       isTransient: true)
         } else {
            // Success.
         }
      }

      XCTAssertEqual(attemptCount, 2)

      let allSleepDurations = clockFake.allSleepDurations
      XCTAssertEqual(allSleepDurations.count, 1)

      if let sleepDuration = allSleepDurations.first {
         // The code being tested relies on `Date.now`, which returns a real timestamp. If we try to
         // use a more precise assertion, the test would become non-deterministic. Instead, assert
         // that the sleep duration is at least greater than a year, so we know a minimum delay is
         // being enforced.
         XCTAssertGreaterThan(sleepDuration, Duration.seconds(1 * 365 * 24 * 60 * 60))
      }
   }

   func testHTTPApplicationErrorWithRetryAfterValue_valueIsDuration_sleepsAtLeastDuration() async throws {
      let clockFake = ClockFake()

      let minDelayInSeconds = 1_000_000

      var attemptCount = 0

      try await HTTPRequest.fake.retry(maxAttempts: nil, clock: clockFake) { request in
         attemptCount += 1

         if attemptCount == 1 {
            var failureResponse = HTTPResponse.transientFailureFake
            failureResponse.headerFields[.retryAfter] = "\(minDelayInSeconds)"

            throw HTTPApplicationError(response: failureResponse,
                                       responseBody: (),
                                       isTransient: true)
         } else {
            // Success.
         }
      }

      XCTAssertEqual(attemptCount, 2)

      let allSleepDurations = clockFake.allSleepDurations
      XCTAssertEqual(allSleepDurations.count, 1)

      if let sleepDuration = allSleepDurations.first {
         XCTAssertGreaterThanOrEqual(sleepDuration, Duration.seconds(minDelayInSeconds))
      }
   }

   func testNonTransientHTTPApplicationErrorWithRetryAfterValue_notRetried() async throws {
      var attemptCount = 0

      do {
         try await HTTPRequest.fake.retry(maxAttempts: nil, clock: ClockFake()) { request in
            attemptCount += 1

            if attemptCount == 1 {
               var failureResponse = HTTPResponse.nonTransientFailureFake
               failureResponse.headerFields[.retryAfter] = "1"

               throw HTTPApplicationError(response: failureResponse,
                                          responseBody: (),
                                          isTransient: false)
            } else {
               // Success.
            }
         }
      } catch is HTTPApplicationError<Void> {
         // Expected.
      }

      XCTAssertEqual(attemptCount, 1)
   }
}
