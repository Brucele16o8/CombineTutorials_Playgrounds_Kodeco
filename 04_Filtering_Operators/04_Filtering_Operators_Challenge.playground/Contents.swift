import Foundation
import Combine

var subscription = Set<AnyCancellable>()

example(of: "Filter All the Things") {
  let numbers = (1...100).publisher
  
  numbers
    .dropFirst(50)
    .prefix(20)
    .filter { $0.isMultiple(of: 2) }
    .sink(receiveValue: { print("\($0)", terminator: " ") })
    .store(in: &subscription)

}
