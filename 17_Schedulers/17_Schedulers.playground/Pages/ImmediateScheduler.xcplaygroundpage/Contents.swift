import Combine
import SwiftUI
import PlaygroundSupport

// ===== ImmediateScheduler
/// ImmediateScheduler: A simple scheduler that executes code immediately on the current thread, which is the default execution context unless modified using subscribe(on:), receive(on:) or any of the other operators which take a scheduler as parameter.

let source = Timer
  .publish(every: 1.0, on: .main, in: .common)
  .autoconnect()
  .scan(0) { counter, _ in counter + 1 }

let setupPublisher = { recorder in
  source
    .receive(on: DispatchQueue.global())
    .recordThread(using: recorder) /// Thread 1 since default thread of Playground is thread 1
    .receive(on: ImmediateScheduler.shared)
    .recordThread(using: recorder) /// Thread 1 since default thread of Playground is thread 1
    .eraseToAnyPublisher()
}


// =====
let view = ThreadRecorderView(title: "Using immediateScheduler", setup: setupPublisher)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)
