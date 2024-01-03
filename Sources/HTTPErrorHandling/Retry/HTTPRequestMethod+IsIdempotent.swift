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

extension HTTPRequest.Method {
   /// Determines whether the HTTP method is idempotent.
   ///
   /// From the [definition](https://httpwg.org/specs/rfc9110.html#idempotent.methods):
   /// > A request method is considered idempotent if the intended effect on the server of multiple
   /// > identical requests with that method is the same as the effect for a single such request.
   public var isIdempotent: Bool {
      switch self {
      case .get,
            .head,
            .options,
            .trace,
            .put,
            .delete:
         return true

      case .post,
            .patch,
            .connect:
         return false

      default:
         return false
      }
   }
}
