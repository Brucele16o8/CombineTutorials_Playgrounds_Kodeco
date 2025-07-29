//
//  CollageNeueModel.swift
//  Collage Neue
//
//  Created by Tung Le on 28/7/2025.
//

import SwiftUI
import Combine
import Photos

class CollageNeueModel: ObservableObject {
  static let collageSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
  
  // MARK: collage
  
  private(set) var lastSavedPhotoID = ""
  private(set) var lastErrorMessage = ""
  @Published var imagePreview: UIImage?
  
  private var subscriptions = Set<AnyCancellable>()
  private let images = CurrentValueSubject<[UIImage], Never>([])
  let updateUISubject = PassthroughSubject<Int, Never>()
  private(set) var selectedphotosSubject = PassthroughSubject<UIImage, Never>()
  
  /// ✅
  func bindMainView() {                           /// Bind MainView
    images
      .handleEvents(
        receiveOutput: { [weak self] photos in
          self?.updateUISubject.send(photos.count)
        })
      .map { photos in
        UIImage.collage(images: photos, size: Self.collageSize)
      }
      .assign(to: &$imagePreview)
  }
  
  /// ✅
  func add() {
    selectedphotosSubject = PassthroughSubject()
    let newPhotos = selectedphotosSubject
      .prefix(while: { [unowned self] _ in
        self.images.value.count < 6
      })
      .share()
    
    newPhotos
      .map { [unowned self] newImage in
        return self.images.value + [newImage]
      }
      .assign(to: \.value, on: images)
      .store(in: &subscriptions)
  }
  
  /// ✅
  func clear() {
    images.send([])
  }
  
  /// ✅
  func save() {
    guard let image = imagePreview else { return }
    
    PhotoWriter.save(image)
      .sink(
        receiveCompletion: { [unowned self] completion in
          if case .failure(let error) = completion {
            lastErrorMessage = error.localizedDescription
          }
          clear()
        },
        receiveValue: { [unowned self] id in
          lastSavedPhotoID = id
        }
      )
      .store(in: &subscriptions)
  }
  
  // MARK: -  Displaying photos picker
  private lazy var imageManager = PHCachingImageManager()
  private(set) var thumbnails = [String : UIImage]()
  private let thumbnailSize: CGSize = .init(width: 200, height: 200)
  
  func bindPhotoPicker() {
    
  }
  
  func loadPhotos() -> PHFetchResult<PHAsset> {
    let allPhotosOptions = PHFetchOptions()
    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    return PHAsset.fetchAssets(with: allPhotosOptions)
  }
  
  // ✅
  /// This function generates a thumbnail for a given PHAsset (e.g. a photo), if it hasn't already been created, and then caches it in a dictionary for quick access later.
  func enqueueThumnail(asset: PHAsset) {
    guard thumbnails[asset.localIdentifier] == nil else { return }  /// Checks if this asset already has a thumbnail store - asset.localIdentifier is a unique string ID for the photo/video.
                                                                    /// If the thumbnail is already in the thumbnails dictionary, the function exits early (avoids duplicate work).
    imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
      guard let image = image else { return }
      self.thumbnails[asset.localIdentifier] = image
    })
  }
  
  func selectImage(asset: PHAsset) {
    imageManager.requestImage(
      for: asset,
      targetSize: UIScreen.main.bounds.size,
      contentMode: .aspectFill,
      options: nil
    ) { [weak self] image, info in
      guard let self = self,
            let image = image,
            let info = info else { return }
      
      if let isThumnail = info[PHImageResultIsDegradedKey] as? Bool, isThumnail {
        /// skip the thumnail version of the asset
        return
      }
      
      /// send the selected image
      self.selectedphotosSubject.send(image)
    }
  }
}
