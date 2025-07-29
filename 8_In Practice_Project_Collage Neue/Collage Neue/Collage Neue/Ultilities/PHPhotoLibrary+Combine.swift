//
//  PHPhotoLibrary+Combine.swift
//  Collage Neue
//
//  Created by Tung Le on 29/7/2025.
//

import Foundation
import Photos
import Combine

extension PHPhotoLibrary {
  
  static var isAuthorized: Future<Bool, Never> {
    Future { promise in
      fetchAuthorizationStatus { status in
          promise(.success(status))
      }
    }
  }
  
  static func fetchAuthorizationStatus(callback: @escaping (Bool) -> Void) {
    /// Fetch the current status
    let currentAuthorized = authorizationStatus() == .authorized
    
    /// If authorized, callback immediately
    guard !currentAuthorized else {
      return callback(currentAuthorized)
    }
    
    ///  Otherwise request access and callback with new status
    requestAuthorization { newStatus in
      callback(newStatus == .authorized)
    }
  }
}
