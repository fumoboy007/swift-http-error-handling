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

final class HTTPResponseInterpretationTests: XCTestCase {
   func testSuccessResponse_noError() throws {
      try HTTPResponse.successFake.throwIfFailed()
   }

   func testFailureResponse_throwsError() throws {
      let response = HTTPResponse.failureFake

      do {
         try response.throwIfFailed()
      } catch let error as HTTPApplicationError<Void> {
         XCTAssertEqual(error.response, response)
      }
   }

   func testTransientFailureResponse_throwsTransientError() throws {
      do {
         try HTTPResponse.transientFailureFake.throwIfFailed()
      } catch let error as HTTPApplicationError<Void> {
         XCTAssertTrue(error.isTransient)
      }
   }

   func testNonTransientFailureResponse_throwsNonTransientError() throws {
      do {
         try HTTPResponse.nonTransientFailureFake.throwIfFailed()
      } catch let error as HTTPApplicationError<Void> {
         XCTAssertFalse(error.isTransient)
      }
   }

   func testAttachResponseBodyToError_errorHasResponseBody() async throws {
      let responseBody = Data()

      do {
         try await HTTPResponse.failureFake.throwIfFailed() {
            return responseBody
         }
      } catch let error as HTTPApplicationError<Data> {
         XCTAssertEqual(error.responseBody, responseBody)
      }
   }

   func testFailureToCreateResponseBody_throwsResponseBodyCreationError() async throws {
      do {
         try await HTTPResponse.failureFake.throwIfFailed() {
            throw ErrorFake()
         }
      } catch is ErrorFake {
         // Expected.
      }
   }
}
