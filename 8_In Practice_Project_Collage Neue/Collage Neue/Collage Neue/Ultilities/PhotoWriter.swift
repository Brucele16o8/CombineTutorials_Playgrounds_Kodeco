//
//  PhotoWriter.swift
//  Collage Neue
//
//  Created by Tung Le on 28/7/2025.
//

import Combine
import Photos
import SwiftUI

class PhotoWriter {
  enum Error: Swift.Error {
    case couldNotSavePhoto
    case generic(Swift.Error)
  }
  
  static func save(_ image: UIImage) -> Future<String, PhotoWriter.Error> {
    return Future { resolve in
      do {
        try PHPhotoLibrary.shared().performChangesAndWait {
          let request = PHAssetChangeRequest.creationRequestForAsset(from: image) /// saves the photo - creates a PHAsset in the photo library from your UIImage
          guard let savedAssetID = request.placeholderForCreatedAsset?.localIdentifier else {
            return resolve(.failure(PhotoWriter.Error.couldNotSavePhoto))
          }
          return resolve(.success(savedAssetID))
        }
      } catch {
        resolve(.failure(.generic(error)))
      }
    }
  }
  
} // 🧱
