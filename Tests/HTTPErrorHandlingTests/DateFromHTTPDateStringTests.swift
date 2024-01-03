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

@testable import HTTPErrorHandling

import Foundation
import XCTest

final class DateFromHTTPDateStringTests: XCTestCase {
   func testPreferredFormat() throws {
      let httpDateString = "Sun, 06 Nov 1994 08:49:37 GMT"

      let date = try XCTUnwrap(Date(httpDateString: httpDateString))

      let expectedDateComponents = DateComponents(
         calendar: Calendar(identifier: .gregorian),
         timeZone: TimeZone(secondsFromGMT: 0),
         year: 1994,
         month: 11,
         day: 6,
         hour: 8,
         minute: 49,
         second: 37
      )
      XCTAssertEqual(date, expectedDateComponents.date!)
   }

   func testObsoleteRFC850Format() throws {
      let httpDateString = "Sunday, 06-Nov-94 08:49:37 GMT"

      let date = try XCTUnwrap(Date(httpDateString: httpDateString))

      let expectedDateComponents = DateComponents(
         calendar: Calendar(identifier: .gregorian),
         timeZone: TimeZone(secondsFromGMT: 0),
         year: 1994,
         month: 11,
         day: 6,
         hour: 8,
         minute: 49,
         second: 37
      )
      XCTAssertEqual(date, expectedDateComponents.date!)
   }

   func testObsoleteAsctimeFormat() throws {
      let httpDateString = "Sun Nov  6 08:49:37 1994"

      let date = try XCTUnwrap(Date(httpDateString: httpDateString))

      let expectedDateComponents = DateComponents(
         calendar: Calendar(identifier: .gregorian),
         timeZone: TimeZone(secondsFromGMT: 0),
         year: 1994,
         month: 11,
         day: 6,
         hour: 8,
         minute: 49,
         second: 37
      )
      XCTAssertEqual(date, expectedDateComponents.date!)
   }
}
