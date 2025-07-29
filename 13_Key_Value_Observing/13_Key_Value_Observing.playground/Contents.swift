import Foundation
import Combine


// Preparing and Subscribing to Your Own KVO-compliant Properties
/// You can also use Key-Value Observing in your own code, provided that:
///
///  -  Your objects are classes (not structs) and conform to NSObject,
///  -  You mark the properties to make observable with the @objc dynamic attributes.
///
/// Once you have done this, the objects and properties you marked become KVO-compliant and can be observed with Combine!

class TestObject: NSObject {
  @objc dynamic var integerProperty: Int = 0
  @objc dynamic var stringProperty: String = ""
  @objc dynamic var arrayProperty: [Float] = []
//  @objc dynamic var structProperty: PureSwift = .init(a: (0,false)) /// PureSwift type that is not bridgeable to the Object-C

}

let obj = TestObject()

let subscription = obj.publisher(for: \.integerProperty)
  .sink {
    print("integerProperty changes to \($0)")
  }

obj.integerProperty = 100
obj.integerProperty = 200
obj.integerProperty = 300


let subcription2 = obj.publisher(for: \.stringProperty)
  .sink {
    print("stringProperty changes to \($0)")
  }

let subcription3 = obj.publisher(for: \.arrayProperty)
  .sink {
    print("arrayProperty changes to \($0)")
  }

obj.stringProperty = "Hello"
obj.arrayProperty = [1.0]
obj.stringProperty = "World"
obj.arrayProperty = [1.0, 2.0]


/// If you ever use a pure-Swift type that isn‘t bridged to Objective-C though, you‘ll start running into trouble:
struct PureSwift {
  let a: (Int, Bool)
}


example(of: "ObservableObject") {
  class MonitorObject: ObservableObject {
    @Published var someProperty = false
    @Published var someOtherProperty: String = ""
  }
  
  let object = MonitorObject()
  let subsciption = object.objectWillChange.sink {
    print("object will change")
  }
  
  object.someProperty = true
  object.someOtherProperty = "Hello World"
}
