import Combine
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


let subject = PassthroughSubject<Int, Never>()

let strings = subject
  .collect(.byTime(DispatchQueue.main, .seconds(0.5)))
  .map { array in
    String(array.map { Character(Unicode.Scalar($0)!)})
  }

let spaces = subject.measureInterval(using: DispatchQueue.main)
  .map { interval in
    interval > 0.9 ? "👏" : ""
  }

let subscription = strings
  .merge(with: spaces)
  .filter { !$0.isEmpty }
  .sink(receiveValue: { print($0) })

startFeeding(subject: subject)
