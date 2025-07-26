import Foundation
import Combine
import SwiftUI
import UIKit

var subscriptions = Set<AnyCancellable>()

// MARK: - PREPENDING
// ===== prepend(Output…)
/// This variation of prepend takes a variadic list of values using the ... syntax. This means it can take any number of values, as long as they’re of the same Output type as the original publisher.
example(of: "prepend(Output…)") {
  let publisher = [3, 4].publisher
  
  publisher
    .prepend(1, 2)
    .prepend(-1, 0)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}


// ===== prepend(Sequence)
/// This variation of prepend is similar to the previous one, with the difference that it takes any Sequence-conforming object as an input. For example, it could take an Array or a Set.
example(of: "prepend(Sequence)") {
  let publisher = [5, 6, 7].publisher
  
  publisher
    .prepend([3, 4])
    .prepend( Set(1...2))
    .prepend(stride(from: 6, to: 11, by: 2))
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

// ===== prepend(Publisher)
/// The two previous operators prepended lists of values to an existing publisher. But what if you have two different publishers and you want to glue their values together? You can use prepend(Publisher) to add values emitted by a second publisher before the original publisher’s values.
example(of: "prepend(Publisher)") {
  let publisher1 = [3, 4].publisher
  let publisher2 = [1, 2].publisher
  
  publisher1
    .prepend(publisher2)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}


example(of: "prepend(Publisher) #2") {
  let publisher1 = [3, 4].publisher
  let publisher2 = PassthroughSubject<Int, Never>()
  
  publisher1
    .prepend(publisher2)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
  
  publisher2.send(1)
  publisher2.send(2)
  publisher2.send(completion: .finished)

}

// MARK: - APPENDING
// append(Output...)
/// append(Output...) works similarly to its prepend counterpart: It also takes a variadic list of type Output but then appends its items after the original publisher has completed with a .finished event.
example(of: "append(Output...)") {
  let publisher = [1].publisher
  
  publisher
    .append(2, 3)
    .append(4)
    .sink(receiveValue: { print($0)} )
    .store(in: &subscriptions)
}

/// Appending works exactly like you’d expect, where each append waits for the upstream to complete before adding its own work to it.
/// This means that the upstream must complete or appending would never occur since Combine couldn’t know the previous publisher has finished emitting all of its values.
example(of: "append(Output...) #2") {
  let publisher = PassthroughSubject<Int, Never>()
  
  publisher
    .append(3, 4)
    .append(5)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
  
  publisher.send(1)
  publisher.send(2)
  publisher.send(completion: .finished)
}

// append(Sequence)
/// This variation of append takes any Sequence-conforming object and appends its values after all values from the original publisher have emitted.
example(of: "append(Sequence)") {
  let publisher = [1, 2, 3].publisher
  
  publisher
    .append([4, 5])
    .append(Set([6, 7]))
    .append(stride(from: 8, to: 11, by: 2))
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

// append(Publisher)
example(of: "append(Publisher)") {
  let publisher1 = [1, 2].publisher
  let publisher2 = [3, 4].publisher
  
  publisher1
    .append(publisher2)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

// switchToLatest
example(of: "switchToLatest") {
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<Int, Never>()
  let publisher3 = PassthroughSubject<Int, Never>()
  
  let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
  
  publishers
    .switchToLatest()
    .sink(
      receiveCompletion: { _ in print("Completed!") },
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)
  
  publishers.send(publisher1)
  publisher1.send(1)
  publisher1.send(2)
  
  publishers.send(publisher2)
  publisher1.send(3)
  publisher2.send(4)
  publisher2.send(5)
  
  publishers.send(publisher3)
  publisher2.send(6)
  publisher3.send(7)
  publisher3.send(8)
  publisher3.send(9)
  
  publisher3.send(completion: .finished)
  publishers.send(completion: .finished)
}

// switchToLatest - Network Request - real case
//example(of: "switchToLatest - Network Request") {
//  let url = URL(string: "https://source.unsplash.com/collection/\(UUID().uuidString)")!
//  
//  func getImage() -> AnyPublisher<UIImage?, Never> {
//    URLSession.shared
//      .dataTaskPublisher(for: url)
//      .delay(for: .seconds(1), scheduler: RunLoop.main) /// Additional code for Swift 6, not needed for Swift 5 -> more resarch needed here!!!
//      .map { data, _ in UIImage(data: data) }
//      .print("image")
//      .replaceError(with: nil)
//      .eraseToAnyPublisher()
//  }
//  
//  let taps = PassthroughSubject<Void, Never>()
//  
//  taps
//    .map { _ in getImage() }
//    .switchToLatest()
//    .sink(receiveValue: { _ in })
//    .store(in: &subscriptions)
//  
//  taps.send()
//  
//  DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//    taps.send()
//  }
//  
//  DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
//    taps.send()
//  }
//}

// ===== Merge
example(of: "merge(with:)") {
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<Int, Never>()
  
  publisher1
    .merge(with: publisher2)
    .sink(
      receiveCompletion: { _ in print("Completed") },
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)
  
  publisher1.send(1)
  publisher1.send(2)
  publisher2.send(3)
  publisher1.send(4)
  publisher2.send(5)
  
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
}

// ===== Combine latest
example(of: "combineLatest") {
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<String, Never>()
  
  publisher1
    .combineLatest(publisher2)
    .sink(
      receiveCompletion: { _ in print("Completed") },
      receiveValue: { print("P1: \($0), P2: \($1)") }
    )
    .store(in: &subscriptions)
  
  publisher1.send(1)
  publisher1.send(2)

  publisher2.send("a")
  publisher2.send("b")

  publisher1.send(3)

  publisher2.send("c")

  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
}

// ===== zip
/// emitting tuples of paired values in the same indexes
example(of: "zip") {
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<String, Never>()
  
  publisher1
    .zip(publisher2)
    .sink(
      receiveCompletion: { _ in print("Completed") },
      receiveValue: { print("P1: \($0), P2: \($1)") }
    )
    .store(in: &subscriptions)
  
  publisher1.send(1)
  publisher1.send(2)
  publisher2.send("a")
  publisher2.send("b")
  publisher1.send(3)
  publisher2.send("c")
  publisher2.send("d")
  
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
}
/// Notice how each emitted value “waits” for the other zipped publisher to emit a value. 1 waits for the first emission from the second publisher, so you get (1, "a"). Likewise, 2 waits for the next emission from the second publisher, so you get (2, "b"). The last emitted value from the second publisher, "d", is ignored since there is no corresponding emission from the first publisher to pair with.
