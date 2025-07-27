import Foundation
import Combine


var subscriptions = Set<AnyCancellable>()

// Starting
// MARK: - Finding values
// ===== min
/// Greedy
example(of: "min") {
  let publisher = [1, -50, 246, 0].publisher
  
  publisher
    .print("publisher")
    .min()
    .sink(receiveValue: { print("Lowest value is \($0)") })
    .store(in: &subscriptions)
}

/// how does Combine know which of these numbers is the minimum? Well, that’s thanks to the fact numeric values conform to the Comparable protocol. You can use min() directly, without any arguments, on publishers that emit Comparable-conforming types.
/// But what happens if your values don’t conform to Comparable? Luckily, you can provide your own comparator closure using the min(by:) operator.
example(of: "min non-comparable") {
  let publisher = ["12345",
                   "ab",
                   "hello world"]
    .map { Data($0.utf8) }
    .publisher  /// Publisher<Data, Never>
  
  publisher
    .print("publisher")
    .min(by: { $0.count < $1.count })
    .sink(
      receiveValue: { data in
        let string = String(data: data, encoding: .utf8)!
        print("Smallest data is '\(string)\', \(data.count) bytes")
      }
    )
    .store(in: &subscriptions)
}


// ===== max
example(of: "max") {
  let publisher = ["A", "F", "Z", "E"].publisher
  publisher
    .print("publisher")
    .max()
    .sink(receiveValue: { print("Highest value is \($0)") })
    .store(in: &subscriptions)
}

// ===== First
/// It’s lazy, meaning it doesn’t wait for the upstream publisher to finish, but instead will cancel the subscription when it receives the first value emitted.
example(of: "first") {
  let publisher = ["A", "B", "C"].publisher
  publisher
    .print("publisher")
    .first()
    .sink(receiveValue: { print("First value is \($0)") })
    .store(in: &subscriptions)
}

// ===== first(where:)
/// Just like its counterpart in the Swift standard library, it will emit the first value that matches a provided predicate — if there is one.
example(of: "first(where:)") {
  let publisher = ["J", "O", "H", "N"].publisher
  
  publisher
    .print("publisher")
    .first(where: { "Hello World!".contains($0) })
    .sink(receiveValue: { print("First match is \($0)") })
    .store(in: &subscriptions)
}

// ===== last
/// last works exactly like first, except it emits the last value that the publisher emits. This means it’s also greedy and must wait for the upstream publisher to finish:
example(of: "last") {
  let publisher = ["A", "B", "C"].publisher
  
  publisher
    .print("publisher")
    .last()
    .sink(receiveValue: { print("Last value is \($0)") })
    .store(in: &subscriptions)
}

// ===== output(at:)
/// The output operators will look for a value emitted by the upstream publisher at the specified index.
example(of: "output(at:)") {
  let publisher = ["A", "B", "C"].publisher
  
  publisher
    .print("publisher")
    .output(at: 1)
    .sink(receiveValue: { print("Value at index 1 is \($0)") })
    .store(in: &subscriptions)
}

// ===== output(in:)
/// While output(at:) emits a single value emitted at a specified index, output(in:) emits values whose indices are within a provided range:
example(of: "output(in:)") {
  let publisher = ["A", "B", "C", "D", "E"].publisher
  
  publisher
    .output(in: 1...3)
    .sink(
      receiveCompletion: { print($0) },
      receiveValue: { print("Value in range: \($0)") }
    )
    .store(in: &subscriptions)
}

// MARK: - Querying
// ===== count
example(of: "count") {
  let publisher = ["A", "B", "C"].publisher
  
  publisher
    .print("publisher")
    .count()
    .sink(receiveValue: { print("I have \($0) items") })
    .store(in: &subscriptions)
}

// MARK: - CONTAINS
// ===== contains
/// The contains operator will emit true and cancel the subscription if the specified value is emitted by the upstream publisher, or false if none of the emitted values are equal to the specified one:
example(of: "contains") {
  let publisher = ["A", "B", "C", "D", "E"].publisher
  let letter = "C"
  
  publisher
    .print("publisher")
    .contains(letter)
    .sink(receiveValue: { contains in
      print(contains ? "Publisher emitted \(letter)!" : "Publisher never emitted \(letter)!")
    })
    .store(in: &subscriptions)
}

// ===== contains(where:)
/// sometimes you want to look for a match for a predicate that you provide or check for the existence of an emitted value that doesn’t conform to Comparable. For these specific cases, you have contains(where:).
example(of: "contains(where:)") {
  struct Person {
    let id: Int
    let name: String
  }
  
  let people = [
    (123, "Shai Mishali"),
    (777, "Marin Todorov"),
    (214, "Florent Pillet")
  ]
    .map(Person.init)
    .publisher
  
  people
    .contains(where: { $0.id == 800 || $0.name == "Marin Todorov" })
    .sink(receiveValue: { contains in
      print(contains ? "Criteria matches!" : "Couldn't find a match for the criteria")
    })
    .store(in: &subscriptions)
}

// ===== allSatisfy
/// You’ll start with allSatisfy, which takes a closure predicate and emits a Boolean indicating whether all values emitted by the upstream publisher match that predicate. It’s greedy and will, therefore, wait until the upstream publisher emits a .finished completion event:
example(of: "allSatisfy") {
  let publisher = stride(from: 0, to: 5, by: 2).publisher
  
  publisher
    .print("publisher")
    .allSatisfy { $0 % 2 == 0 }
    .sink(receiveValue: { allEven in
      print(allEven ? "All numbers are even"  : "Something is odd...")
    })
    .store(in: &subscriptions)
}

/// However, if even a single value doesn’t pass the predicate condition, the operator will emit false immediately and will cancel the subscription.
example(of: "allSatisfy") {
  let publisher = stride(from: 0, to: 5, by: 1).publisher
  
  publisher
    .print("publisher")
    .allSatisfy { $0 % 2 == 0 }
    .sink(receiveValue: { allEven in
      print(allEven ? "All numbers are even"  : "Something is odd...")
    })
    .store(in: &subscriptions)
}

// ===== reduce
example(of: "reduce") {
  let publisher = ["Hel", "lo", " ", "Wor", "ld", "!"].publisher
  
  publisher
      .print("publisher")
      .reduce("") { accumulator, value in
        accumulator + value
      }
      .sink(receiveValue: { print("Reduced into: \($0)") })
      .store(in: &subscriptions)
}
