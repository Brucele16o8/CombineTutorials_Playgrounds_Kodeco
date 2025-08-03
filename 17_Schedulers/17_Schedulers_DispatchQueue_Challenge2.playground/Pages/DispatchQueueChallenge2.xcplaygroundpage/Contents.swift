import Combine
import SwiftUI
import PlaygroundSupport

// Challenge 2: determine whether Combine of Dispatch is optimizing queue hoping

let sourceQueue = DispatchQueue.main
let serialQueue = DispatchQueue(label: "Serial queue")

let serialQueue2 = DispatchQueue(label: "Second serial queue", target: serialQueue)

let source = PassthroughSubject<Void, Never>()
let subscription = sourceQueue.schedule(after: sourceQueue.now, interval: .seconds(1)) {
  source.send()
}

let setupPublisher = { recorder in
  return source
    .receive(on: serialQueue)
    .recordThread(using: recorder)
    .receive(on: serialQueue2)
    .recordThread(using: recorder)
    .eraseToAnyPublisher()
}

let view = ThreadRecorderView(title: "Using DispatchQueue", setup: setupPublisher)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)
