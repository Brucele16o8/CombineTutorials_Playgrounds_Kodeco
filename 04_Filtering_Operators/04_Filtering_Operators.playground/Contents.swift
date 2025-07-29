import Foundation
import Combine

var subscrpitions = Set<AnyCancellable>()

// ===== Filter
example(of: "filter") {
  let numbers = (1...10).publisher
  
  numbers
    .filter { $0.isMultiple(of: 3) }
    .sink(
      receiveCompletion: { print($0) },
      receiveValue: { n in
        print("\(n) is a multiple of 3!")
      }
    )
    .store(in: &subscrpitions)
}

// ===== remove duplicate
example(of: "removeDupicates") {
  let words = "hey hey there! want to listen to mister mister mister hey hey?"
    .components(separatedBy: " ")
    .publisher
  
  words
    .removeDuplicates()
    .sink(receiveValue: { print($0) })
    .store(in: &subscrpitions)
}

// ===== compact map
example(of: "compactMap") {
  let strings = ["a", "1.24", "3", "def", "45", "0.23"].publisher
  
  strings
    .compactMap { Float($0) }
    .sink(receiveValue: { print($0) })
    .store(in: &subscrpitions)
}


// ===== Ignoring output
example(of: "ignoreOutput") {
  let numbers = (1...1000).publisher
  
  numbers
    .ignoreOutput()
    .sink(
      receiveCompletion: { print("Completed with: \($0)") },
      receiveValue: { print($0) }
    )
    .store(in: &subscrpitions)
}

// ===== first(where:)
/// This operator is  lazy, meaning: It only takes as many values as it needs until it finds one matching the predicate you provided.
example(of: "first(where:)") {
  let numbers = (1...9).publisher
  
  numbers
    .print("numbers")
    .first(where: { $0 % 2 == 0})
    .sink(
      receiveCompletion: { print("Completed with: \($0)") },
      receiveValue: { print($0) }
    )
    .store(in: &subscrpitions)
}


// ===== last(where:)
/// As opposed to first(where:), this operator is greedy since it must wait for the publisher to complete emitting values to know whether a matching value has been found.
example(of: "last(where:)") {
  let numbers = (1...9).publisher
  
  numbers
    .last(where: { $0 % 2 == 0 })
    .sink(
      receiveCompletion: { print("Completed with: \($0)") },
      receiveValue: { print($0) }
    )
    .store(in: &subscrpitions)
}

// MARK: - DROP
// ===== Dropping values - default to 1
example(of: "dropFirst") {
  let numbers = (1...10).publisher
  
  numbers
    .dropFirst(3)
    .sink(receiveValue: { print($0) })
    .store(in: &subscrpitions)
}

// ===== drop(while:)
/// This is another extremely useful variation that takes a predicate closure and ignores any values emitted by the publisher until the first time that predicate is met.
example(of: "drop(while:)") {
  let numbers = (1...10).publisher
  
  numbers
    .drop(while: {
      print("x")
      return $0 % 5 != 0
    })
    .sink(receiveValue: { print($0) })
    .store(in: &subscrpitions)
}

// ===== drop(untilOutputFrom:)
example(of: "drop(untilOutputFrom:)") {
  let isReady = PassthroughSubject<Void, Never>()
  let taps = PassthroughSubject<Int, Never>()
  
  taps
    .drop(untilOutputFrom: isReady)
    .sink(
      receiveCompletion: { print($0) },
      receiveValue: { print($0) }
    )
    .store(in: &subscrpitions)
  
  (1...5).forEach { n in
    taps.send(n)
    
    if n == 3 {
      isReady.send()
    }
  }
}

// - MARK: - PREFIX
// ===== prefix
example(of: "prefix") {
  let numbers = (1...10).publisher
  
  numbers
    .prefix(2)
    .sink(
      receiveCompletion: { print("Completed with: \($0)") },
      receiveValue: { print($0) }
    )
    .store(in: &subscrpitions)
}

// ===== prefix(while:)
/// As the opposite of dropFirst, prefix(_:) will take values only up to the provided amount and then complete:
example(of: "prefix(while:)") {
  let numbers = (1...10).publisher
  
  numbers
    .prefix(while: { $0 < 3 })
    .sink(
      receiveCompletion: { print("Completed with: \($0)") },
      receiveValue: { print($0) }
    )
    .store(in: &subscrpitions)
}


// prefix(untilOutputFrom:)
example(of: "prefix(untilOutputFrom:)") {
  let isReady = PassthroughSubject<Void, Never>()
  let taps = PassthroughSubject<Int, Never>()
  
  taps
    .prefix(untilOutputFrom: isReady)
    .sink(
      receiveCompletion: { print($0) },
      receiveValue: { print($0) }
    )
    .store(in: &subscrpitions)
  
  (1...5).forEach { n in
    taps.send(n)
    
    if n == 2 {
      isReady.send()
    }
  }
}


