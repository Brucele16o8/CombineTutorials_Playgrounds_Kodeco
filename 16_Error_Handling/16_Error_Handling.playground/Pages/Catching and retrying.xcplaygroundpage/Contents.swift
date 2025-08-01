import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

let photoService = PhotoService()

example(of: "Catching and retrying") {
  photoService
    .fetchPhoto(quality: .high/*, failingTimes: 2*/)
    .handleEvents(
      receiveSubscription: { _ in print("Trying ...") },
      receiveCompletion: {
        guard case .failure(let error) = $0 else { return }
        print("Got error: \(error)")
      }
    )
    .retry(3)
//    .replaceError(with: UIImage(named: "na.jpg")!)
    .catch { error -> PhotoService.Publisher in
      print("Failed fetching high quality, falling back to low quality")
      return photoService.fetchPhoto(quality: .low)
    }
    .sink(
      receiveCompletion: { print("\($0)") },
      receiveValue: { image in
        image
        print("Got image: \(image)")
      }
    )
    .store(in: &subscriptions)
}
