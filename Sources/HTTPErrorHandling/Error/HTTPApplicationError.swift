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

/// A concrete error type that contains details about an HTTP application failure.
public struct HTTPApplicationError<ResponseBodyType>: Error {
   /// The response to the failed request.
   public let response: HTTPResponse

   /// The response body, which may contain additional information about the failure.
   ///
   /// - SeeAlso: ``HTTPApplicationErrorProtocol/anyResponseBody``
   public let responseBody: ResponseBodyType

   /// Whether the failure is transient.
   ///
   /// If the failure is transient, a subsequent attempt may succeed. If the failure is not transient, subsequent
   /// attempts will never succeed.
   public let isTransient: Bool

   /// Initializes the error.
   ///
   /// - Parameters:
   ///    - response: The response to the failed request.
   ///    - responseBody: The response body, which may contain additional information about the failure.
   ///    - isTransient: Whether the failure is transient. If the failure is transient, a subsequent
   ///       attempt may succeed. If the failure is not transient, subsequent attempts will never succeed.
   public init(response: HTTPResponse,
               responseBody: ResponseBodyType,
               isTransient: Bool) {
      self.response = response
      self.responseBody = responseBody

      self.isTransient = isTransient
   }
}

extension HTTPApplicationError: HTTPApplicationErrorProtocol {
   public var anyResponseBody: Any {
      return responseBody
   }
}
