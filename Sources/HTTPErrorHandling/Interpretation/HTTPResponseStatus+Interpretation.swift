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

/// Adds static properties to access common sets of HTTP response statuses.
extension HTTPResponse.Status {
   /// Statuses that are commonly used to indicate success.
   public static let successes = Set((200..<300).map(HTTPResponse.Status.init))

   /// Statuses that are commonly used to indicate transient failures.
   ///
   /// If the failure is transient, a subsequent attempt may succeed. If the failure is not transient, subsequent
   /// attempts will never succeed.
   public static let transientFailures: Set<HTTPResponse.Status> = [
      .requestTimeout,
      .tooManyRequests,
      .internalServerError,
      .badGateway,
      .serviceUnavailable,
      .gatewayTimeout
   ]
}
