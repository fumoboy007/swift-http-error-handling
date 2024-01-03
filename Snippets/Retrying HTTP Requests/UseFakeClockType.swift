// Use a fake `Clock` type for deterministic and efficient automated tests.

// snippet.hide

import Foundation
import HTTPErrorHandling
import HTTPTypes
import XCTest

// snippet.show

final class MyServiceImplementation<ClockType: Clock> where ClockType.Duration == Duration {
   private let clock: ClockType

   init(clock: ClockType) {
      self.clock = clock
   }

   func reliablyPerform(_ request: HTTPRequest) async throws {
      try await request.retry(clock: clock) { request in
         let response = try await perform(request)
         try response.throwIfFailed()
      }
   }
}

final class MyServiceImplementationTests: XCTestCase {
   func testReliablyPerformRequest_succeeds() async throws {
      let myService = MyServiceImplementation(clock: ClockFake())
      try await myService.reliablyPerform(requestFake)
   }
}

// snippet.hide

class ClockFake: Clock, @unchecked Sendable {
   typealias Instant = ContinuousClock.Instant

   private let lock = NSLock()

   init() {
      let realClock = ContinuousClock()
      self._now = realClock.now
      self.minimumResolution = realClock.minimumResolution
   }

   private var _now: Instant
   var now: Instant {
      lock.lock()
      defer {
         lock.unlock()
      }

      return _now
   }

   let minimumResolution: Duration

   func sleep(until deadline: Instant,
              tolerance: Duration?) async throws {
      // Refactored into a non-async method so that `NSLock.lock` and `NSLock.unlock` can be used.
      // Cannot use the async-safe `NSLock.withLocking` method until the following change is released:
      // https://github.com/apple/swift-corelibs-foundation/pull/4736
      sleep(until: deadline)
   }

   private func sleep(until deadline: Instant) {
      lock.lock()
      defer {
         lock.unlock()
      }

      _now = max(deadline, _now)
   }
}

let requestFake = HTTPRequest(method: .get,
                              scheme: "https",
                              authority: "example.com",
                              path: "/")

func perform(_ request: HTTPRequest) async throws -> HTTPResponse {
   return HTTPResponse(status: .ok)
}
