import Combine
import SwiftUI
import PlaygroundSupport


let serialQueue = DispatchQueue(label: "serialQueue")
let sourceQueue = DispatchQueue.main

let source = PassthroughSubject<Void, Never>()

let subscription = serialQueue
  .schedule(
    after: sourceQueue.now,
    interval: .seconds(1)) {
      source.send()
    }

let setupPublisher = { recorder in
  source
    .recordThread(using: recorder)
    .receive(
      on: serialQueue,
      options: DispatchQueue.SchedulerOptions(qos: .userInteractive)
    )
    .recordThread(using: recorder)
    .eraseToAnyPublisher()
}


// =====
let view = ThreadRecorderView(title: "Using DispatchQueue",
                              setup: setupPublisher)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

