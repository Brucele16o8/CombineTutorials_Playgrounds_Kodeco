import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// ===== Collect
example(of: "collect") {
  ["A", "B", "C", "D", "E"].publisher
    .collect(2)
    .sink(
      receiveCompletion: { print($0) },
      receiveValue: { print($0) },
    )
    .store(in: &subscriptions)
}

// ===== Map
example(of: "map") {
  let formatter = NumberFormatter()
  formatter.numberStyle = .spellOut
  
  [123, 4, 56].publisher
    .map {
      formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
    }
    .sink(
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)
}

// ===== Mapping key paths
example(of: "mapping key paths") {
  let publisher = PassthroughSubject<Coordinate, Never>()
  
  publisher
    .map(\.x, \.y)
    .sink(
      receiveValue: { x, y in
        print("The coordinate at (\(x), \(y)) is in quadrant", quadrantOf(x: x, y: y))
      }
    )
    .store(in: &subscriptions)
  
  publisher.send(Coordinate(x: 10, y: -8))
  publisher.send(Coordinate(x: 0, y: 5))
}

// ===== tryMap
example(of: "tryMap") {
  Just("Dicrectory name that does not exist")
    .tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
    .sink(
      receiveCompletion: { print($0) },
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)
}

// ===== flatMap
example(of: "flatMap") {
  func decode(_ codes: [Int]) -> AnyPublisher<String, Never> {
    Just(
      codes
        .compactMap { code in
          guard(32...255).contains(code) else { return nil }
          return String(UnicodeScalar(code) ?? " ")
        }
        .joined()
    )
    .eraseToAnyPublisher()
  }
  
  [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33].publisher
    .collect()
    .flatMap(decode)
    .sink(
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)
}

// ===== replace nil with
/// Note: replaceNil(with:) has overloads which can confuse Swift into picking the wrong one for your use case. This results in the type remaining as Optional<String> instead of being fully unwrapped. The code above uses eraseToAnyPublisher() to work around that bug. You can learn more about this issue in the Swift forums: https://bit.ly/30M5Qv7
example(of: "replaceNil") {
  ["A", nil, "C"].publisher
    .eraseToAnyPublisher()
    .replaceNil(with: "-")
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

// ===== replace Empty with
example(of: "replaceEmpty(with:") {
  let empty = Empty<Int, Never>()
  empty
    .replaceEmpty(with: 1)
    .sink(
      receiveCompletion: { print($0) },
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)
}

// ===== Scan
example(of: "scan") {
  var dailyGainLoss: Int { .random(in: -10...10) }
  let august2019 = (0..<22)
    .map { _ in dailyGainLoss }
    .publisher
  
  august2019
    .scan(50) { latest, current in
      max(0, latest + current)
    }
    .sink(receiveValue: { _ in })
    .store(in: &subscriptions)
}
