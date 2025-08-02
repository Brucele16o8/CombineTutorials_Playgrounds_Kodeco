import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

private var subscriptions = Set<AnyCancellable>()

let computationPublisher = Publishers.ExpensiveComputation(duration: 3)

let queue = DispatchQueue(label: "serial queue")

let currentThread = Thread.current.number
print("Start computation publisher on thread \(currentThread)")

// =====
//example(of: "subscribeOn") {
//  computationPublisher
//    .subscribe(on: queue)
//    .sink { value in
//      let thread = Thread.current.number
//      print("Received computation result on thread \(thread): '\(value)'")
//    }
//    .store(in: &subscriptions)
//}

// =====
example(of: "receive(on:)") {
  computationPublisher
    .subscribe(on: queue)
    .receive(on: DispatchQueue.main)
    .sink { value in
      let thread = Thread.current.number
      print("Received computation result on thread \(thread): '\(value)'")
    }
    .store(in: &subscriptions)
}


