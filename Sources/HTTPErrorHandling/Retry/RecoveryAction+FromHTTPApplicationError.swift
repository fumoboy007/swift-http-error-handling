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

import Retry

extension RecoveryAction {
   init(_ error: any HTTPApplicationErrorProtocol, clock: ClockType) {
      guard error.isTransient else {
         self = .throw
         return
      }

      // The HTTP `Retry-After` value is a UTC time or duration. Therefore, the value
      // should only be applicable when the clock is continuous like UTC time.
      guard let now = clock.now as? ContinuousClock.Instant else {
         self = .retry
         return
      }

      switch error.response.retryAfterValue {
      case .date(let nextRetryMinDate):
         let nextRetryMinDelayInSeconds = nextRetryMinDate.timeIntervalSinceNow
         let nextRetryMinDelay = Duration.seconds(1) * nextRetryMinDelayInSeconds
         self = .retryAfter((now + nextRetryMinDelay) as! ClockType.Instant)

      case .durationInSeconds(let nextRetryMinDelayInSeconds):
         let nextRetryMinDelay = Duration.seconds(1) * nextRetryMinDelayInSeconds
         self = .retryAfter((now + nextRetryMinDelay) as! ClockType.Instant)

      case .none:
         self = .retry
      }
   }
}
