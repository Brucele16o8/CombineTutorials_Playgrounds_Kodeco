import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// =====
example(of: "Never sink") {
  Just("Hello")
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

// =====
enum MyError: Error {
  case ohNo
}

example(of: "setFailureType") {
  Just("Hello")
    .setFailureType(to: MyError.self)
    .eraseToAnyPublisher()
    .sink(
      receiveCompletion: { completion in
        switch completion {
        case .failure(.ohNo):
          print("Finished with Oh No!")
        case .finished:
          print("Finished successfully!")
        }
      },
      receiveValue: { value in
        print("Got value: \(value)")
      }
    )
    .store(in: &subscriptions)
}


// =====
example(of: "assign(to:on:)") {
  class Person {
    let id = UUID()
    var name = "Unknown"
  }
  
  let person = Person()
  print("1", person.name)
  
  Just("Shai")
    .handleEvents( // 3
      receiveCompletion: { _ in print("2", person.name) }
    )
    .assign(to: \.name, on: person) // 4
    .store(in: &subscriptions)
}

/// strong reference - retain circle problem with assign(to:on:)

// =====
//example(of: "assign(to:)") {
//  class MyViewModel {
//    @Published var currentDate = Date()
//    
//    init() {
//      Timer.publish(every: 1, on: .main, in: .common)
//        .autoconnect()
//        .prefix(3)
//        .assign(to: &$currentDate)
//    }
//  }
//  
//  let vm = MyViewModel()
//  vm.$currentDate
//    .sink(receiveValue: { print($0) })
//    .store(in: &subscriptions)
//}

// ===== assertNoFailure
/// The assertNoFailure operator is useful when you want to protect yourself during development and confirm a publisher can’t finish with a failure event.
/// It doesn’t prevent a failure event from being emitted by the upstream. However, it will crash with a fatalError if it detects an error, which gives you a good incentive to fix it in development.
example(of: "assertNoFailure") {
  Just("Hello")
    .setFailureType(to: MyError.self)
    .tryMap { _ in throw MyError.ohNo }
    .assertNoFailure()
    .sink(receiveValue: { print("Got value: \($0) ")})
    .store(in: &subscriptions)
}

