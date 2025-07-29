//
//  UIViewController+Combine.swift
//  Collage Neue
//
//  Created by Tung Le on 29/7/2025.
//

import Foundation
import Combine
import SwiftUI

extension UIViewController {
  func alert(title: String, text: String?) -> AnyPublisher<Void, Never> {
    let alertVC = UIAlertController(
      title: title,
      message: text,
      preferredStyle: .alert
    )
    
    return Future { resolve in
      alertVC.addAction(UIAlertAction(
        title: "Close",
        style: .default) { _ in
          resolve(.success(()))
        })
      
      self.present(alertVC, animated: true, completion: nil)
    }
    .handleEvents(
      receiveCancel: {
        self.dismiss(animated: true)
      }
    )
    .eraseToAnyPublisher()
  }
}
