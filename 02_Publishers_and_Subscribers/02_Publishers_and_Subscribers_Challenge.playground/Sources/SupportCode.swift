//
//  SupportedCode.swift
//  
//
//  Created by Tung Le on 25/7/2025.
//

public func example(of description: String, action: () -> Void ) {
  print("\n---- Example: \(description) ----")
  action()
}

public let cards = [
  ("🂡", 11), ("🂢", 2), ("🂣", 3), ("🂤", 4), ("🂥", 5), ("🂦", 6), ("🂧", 7), ("🂨", 8), ("🂩", 9), ("🂪", 10), ("🂫", 10), ("🂭", 10), ("🂮", 10),
  ("🂱", 11), ("🂲", 2), ("🂳", 3), ("🂴", 4), ("🂵", 5), ("🂶", 6), ("🂷", 7), ("🂸", 8), ("🂹", 9), ("🂺", 10), ("🂻", 10), ("🂽", 10), ("🂾", 10),
  ("🃁", 11), ("🃂", 2), ("🃃", 3), ("🃄", 4), ("🃅", 5), ("🃆", 6), ("🃇", 7), ("🃈", 8), ("🃉", 9), ("🃊", 10), ("🃋", 10), ("🃍", 10), ("🃎", 10),
  ("🃑", 11), ("🃒", 2), ("🃓", 3), ("🃔", 4), ("🃕", 5), ("🃖", 6), ("🃗", 7), ("🃘", 8), ("🃙", 9), ("🃚", 10), ("🃛", 10), ("🃝", 10), ("🃞", 10)
]

public typealias Card = (String, Int)
public typealias Hand = [Card]

public extension Hand {
  var cardString: String {
    map { $0.0 }.joined()
  }
  
  var points: Int {
    map { $0.1 }.reduce(0, +)
  }
}

public enum HandError: Error, CustomStringConvertible {
  case busted
  
  public var description: String {
    switch self {
    case .busted:
      return "Busted!"
    }
  }
}
