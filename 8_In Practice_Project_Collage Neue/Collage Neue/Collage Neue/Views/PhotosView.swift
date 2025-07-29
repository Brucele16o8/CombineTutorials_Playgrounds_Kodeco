//
//  Untitled.swift
//  Collage Neue
//
//  Created by Tung Le on 29/7/2025.
//

import SwiftUI
import Photos
import Combine

struct PhotosView: View {
  @EnvironmentObject var model: CollageNeueModel
  @Environment(\.dismiss) var dismiss
  
  let columns: [GridItem] = [.init(.adaptive(minimum: 100, maximum: 200))]
  
  @State private var subsciptions = Set<AnyCancellable>()
  
  @State private var photos = PHFetchResult<PHAsset>()
  @State private var imageManager = PHCachingImageManager()
  @State private var isDisplayingError = false
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 2) {
          ForEach((0..<photos.count), id: \.self) { index in
            let asset = photos[index]
            let _ = model.enqueueThumnail(asset: asset)
            
            Button(action: {
              model.selectImage(asset: asset)
            }, label: {
              Image(uiImage: model.thumbnails[asset.localIdentifier] ?? UIImage(named: "IMG_1907") ?? UIImage())
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .clipShape(
                  RoundedRectangle(cornerRadius: 5)
                )
                .padding(4)
            })
          }
        }
        .padding()
      }
      .navigationTitle("Photos")
      .toolbar {
        Button("Close", role: .cancel) {
          dismiss()
        }
      }
      .alert("No access to the Camera Roll", isPresented: $isDisplayingError, actions: { }, message: {
        Text("You can grant access to Collage Neue from the Settings app")
      })
      .onAppear {
        /// Check for Photos access authorization and reload the list if authorized.
        PHPhotoLibrary.fetchAuthorizationStatus { status in
          if status {
            DispatchQueue.main.async {
              self.photos = model.loadPhotos()
            }
          }
        }
        
        model.bindPhotoPicker()
      }
      .onDisappear {
        model.selectedphotosSubject.send(completion: .finished)
      }
    }
  }
}

#Preview {
  PhotosView()
    .environmentObject(CollageNeueModel())
}
