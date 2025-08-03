import Combine
import SwiftUI
import PlaygroundSupport

let serialQueue = DispatchQueue(label: "Serial queue")
let sourceQueue = DispatchQueue.main

let source = PassthroughSubject<Void, Never>()
let subscription = sourceQueue.schedule(after: sourceQueue.now, interval: .seconds(1)) {
  source.send()
}

let setupPublisher = { recorder in
  return source
    .recordThread(using: recorder)
    .receive(on: serialQueue)
    .recordThread(using: recorder)
    .eraseToAnyPublisher()
}

let view = ThreadRecorderView(title: "Using DispatchQueue", setup: setupPublisher)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

// ===== Challenge 1: first method
serialQueue
  .schedule(after: serialQueue.now.advanced(by: .seconds(4))) {
    subscription.cancel()
  }


// ===== Challenge 1: second method
serialQueue
  .asyncAfter(deadline: .now() + 4) {
    subscription.cancel()
  }
