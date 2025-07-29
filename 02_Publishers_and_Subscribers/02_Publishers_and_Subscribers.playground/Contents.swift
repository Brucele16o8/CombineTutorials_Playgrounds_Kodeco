import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// =====
example(of: "Publisher") {
  let myNotification = Notification.Name("MyNotification")
  
  let publisher = NotificationCenter.default
    .publisher(for: myNotification, object: nil)
    
  let center = NotificationCenter.default
  
  let observer = center.addObserver(forName: myNotification, object: nil, queue: nil) { notification in
    print("Notification received!")
  }
  
  center.post(name: myNotification, object: nil)
  
  center.removeObserver(observer)
}

// =====
example(of: "Subscriber") {
  let myNotification = Notification.Name("MyNotification")
  let center = NotificationCenter.default
  
  let publisher = center.publisher(for: myNotification, object: nil)
  
  let subscription = publisher
    .sink { _ in
      print("Notification received from a publisher!")
    }
  
  center.post(name: myNotification, object: nil)
  subscription.cancel()
  
}

// =====
example(of: "Just") {
  let just = Just("Hello world")
  _ = just.sink(
    receiveCompletion: {
      print("Received completion", $0)
    },
    receiveValue: {
      print("Received value", $0)
    }
  )
}

// =====
example(of: "assign(to:on:") {
  class SomeObject {
    var value: String = "" {
      didSet {
        print(value)
      }
    }
  }
  
  let object = SomeObject()
  let publisher = ["Hello", "World!"].publisher
  
  _ = publisher
    .assign(to: \.value, on: object)
}

// =====
example(of: "assign(to:)") {
  class SomeObject {
    @Published var value = 0
  }
  
  let object = SomeObject()
  
  object.$value
    .sink {
      print($0)
    }
  
  (0..<10).publisher
    .assign(to: &object.$value)
}


// =====
example(of: "Custom Subscriber") {
  let publisher = (1...6).publisher
  
  final class IntSubscriber: Subscriber {
    
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: any Subscription) {
      subscription.request(.max(3))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
      print("Received Input: \(input)")
      return .max(1)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
      print("Received Completion", completion)
    }
  }
  
  let intSubscriber = IntSubscriber()
  publisher.subscribe(intSubscriber)
}

// =====
example(of: "Future") {
  func futureIncrement(
    integer: Int,
    afterDelay delay: TimeInterval
  ) -> Future<Int, Never> {
    Future { promise in
      print("Future - Original")
      DispatchQueue.global().asyncAfter(deadline: .now() + delay)  {
        promise(.success(integer + 1))
      }
    }
  }

  let future = futureIncrement(integer: 1, afterDelay: 2)
  future
    .print("Future")
    .receive(on: DispatchQueue.main)
    .sink(
      receiveCompletion: { print("First Future:", $0) },
      receiveValue: { print("First Future:", $0) }
    )
    .store(in: &subscriptions)
  
  future
    .print("Future")
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { print("Second Future:", $0) },
          receiveValue: { print("Second Future:", $0) })
    .store(in: &subscriptions)

}

// MARK: - Subjects
example(of: "PassthroughSubject") {
  enum MyError: Error {
    case test
  }
  
  let stringPublisher = ["Hello", "World", "!"].publisher
  
  final class StringSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = MyError
    
    func receive(subscription: any Subscription) {
      subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
      print("Received value", input)
      return input == "World" ? .max(1) : .none
    }
    
    func receive(completion: Subscribers.Completion<MyError>) {
      print("Received completion", completion)
    }
  }
  
  let subject = PassthroughSubject<String, MyError>()
  let subcriber = StringSubscriber()
  subject.subscribe(subcriber)
  
  let subscription = subject
    .sink(
      receiveCompletion: { completion in
        print("Received completion (sink), completion")
      },
      receiveValue: { value in
        print("Received value (sink)", value)
      }
    )
  
  subject.send("Hello")
  subject.send("World")
  subscription.cancel()
  subject.send("Still there?")
  subject.send(completion: .failure(MyError.test))
  subject.send(completion: .finished)
  subject.send("How about another one?")
}

// =====
example(of: "CurrentValueSubject") {
  var subscriptions = Set<AnyCancellable>()
  
  let subject = CurrentValueSubject<Int, Never>(0)
  
  subject
    .print()
    .sink(
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)
  
  subject.send(1)
  subject.send(2)
  
  print(subject.value) /// Unlike a passthrough subject, you can ask a current value subject for its value at any time.
  
  subject.value = 3
  print(subject.value)
  
  subject
    .print()
    .sink(receiveValue: { print("Second subscription:", $0) })
    .store(in: &subscriptions)

  subject.send(completion: .finished)
}

// =====
example(of: "Dynamically adjusting Demand") {
  final class IntSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: any Subscription) {
      subscription.request(.max(2))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
      print("Received value", input)
      
      switch input {
      case 1:
        return .max(2)
      case 3:
        return .max(1)
      default:
        return .none
      }
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
      print("Receive completion:", completion)
    }
  }
  
  let subscriber = IntSubscriber()
  let subject = PassthroughSubject<Int, Never>()
  subject.subscribe(subscriber)
  
  subject.send(1)
  subject.send(2)
  subject.send(3)
  subject.send(4)
  subject.send(5)
  subject.send(6)
  subject.send(completion: .finished)
}


// ===== Type Erase
example(of: "Type erasure") {
  let subject = PassthroughSubject<Int, Never>()
  
  let publisher = subject.eraseToAnyPublisher()
  
  publisher
    .sink(receiveValue: { print($0)} )
    .store(in: &subscriptions)
  
  subject.send(0)
}

// ===== Bridging Combine Publishers to async/await ====== ⚠️ Haven't found a solution to bridge Combine to async/await --> Need to consider continuation with yield
example(of: "async/await") {
  let subject = CurrentValueSubject<Int, Never>(0)
  
  Task {
    for await element in subject.values {
      print("Element: \(element)")
    }
    print("Completed.")
  }
  
  Task {
    try? await Task.sleep(nanoseconds: 1000_000_000)
    subject.send(1)
    subject.send(2)
    subject.send(3)
    subject.send(completion: .finished)
  }
}
