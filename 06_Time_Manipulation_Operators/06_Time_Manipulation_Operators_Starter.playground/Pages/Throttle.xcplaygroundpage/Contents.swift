import Combine
import SwiftUI
import PlaygroundSupport

print("\n--- Throttle ---\n")

let throttleDelay = 1.0

let subject = PassthroughSubject<String, Never>()

let throttled = subject
  .throttle(for: .seconds(throttleDelay), scheduler: DispatchQueue.main, latest: true)
  .share()

// ===== Subscriptions
let subscription1 = subject
  .sink { string in
    print("+\(deltaTime)s: Subject emitted: \(string)")
  }

let subscription2 = throttled
  .sink { string in
    print("+\(deltaTime)s: Throttled emitted: \(string)")
  }

subject.feed(with: typingHelloWorld)

// MARK: - DISPLAY
let subjectTimeline = TimelineView(title: "Emitted values")
let throttledTimeline = TimelineView(title: "Throttled values")

let view = VStack(spacing: 100) {
  subjectTimeline
  throttledTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

subject.displayEvents(in: subjectTimeline)
throttled.displayEvents(in: throttledTimeline)

  
