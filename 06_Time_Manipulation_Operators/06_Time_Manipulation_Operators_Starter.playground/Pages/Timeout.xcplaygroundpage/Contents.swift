import Combine
import SwiftUI
import PlaygroundSupport

print("\n--- Timeout ---\n")
///  Its primary purpose is to semantically distinguish an actual timer from a timeout condition. Therefore, when a timeout operator fires, it either completes the publisher or emits an error you specify. In both cases, the publisher terminates.

enum TimeoutError: Error {
  case timedOut
}


let subject = PassthroughSubject<Void, TimeoutError>()

let timedOutSubject = subject.timeout(
  .seconds(5),
  scheduler: DispatchQueue.main,
  customError: { .timedOut }
)

// MARK: - Subcriptions

// MARK: - DISPLAY
let timeline = TimelineView(title: "Button taps")

let view = VStack(spacing: 100) {
  // 1
  Button(action: { subject.send() }) {
    Text("Press me within 5 seconds")
  }
  timeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

timedOutSubject.displayEvents(in: timeline)

