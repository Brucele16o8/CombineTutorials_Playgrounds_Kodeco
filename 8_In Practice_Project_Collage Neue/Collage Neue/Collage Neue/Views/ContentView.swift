//
//  ContentView.swift
//  Collage Neue
//
//  Created by Tung Le on 28/7/2025.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var model: CollageNeueModel
  
  @State private var isDisplayingSavedMessage = false
  
  @State private var lastErrorMessage = "" {
    didSet {
      isDisplayingSavedMessage = true
    }
  }
  
  @State private var isDisplayingPhotoPicker = false
  
  @State private(set) var saveIsEnabled = true
  @State private(set) var clearIsEnabled = true
  @State private(set) var addIsEnabled = true
  @State private(set) var title = ""
  
  var body: some View {
    VStack {
      HStack {
        Text(title)
          .font(.title)
          .fontWeight(.bold)
        Spacer()
        Button(action: {        /// Add button
          model.add()
          isDisplayingPhotoPicker = true
        }, label: {
          Text("+")
            .font(.title)
        })
        .disabled(!addIsEnabled)
        .padding(.bottom)
        .padding(.bottom)
      } /// - HStack
      
      Image(uiImage: model.imagePreview ?? UIImage())  /// Display ImagePreview
        .resizable()
        .frame(height: 200, alignment: .center)
        .border(Color.gray, width: 2)
      
      Button(action: {            /// Clear Button
        model.clear()
      }, label: {
        Text("Clear")
          .fontWeight(.bold)
          .frame(maxWidth: .infinity)
      })
      .disabled(!clearIsEnabled)
      .buttonStyle(.bordered)
      .padding(.vertical)
      
      
      Button(action: {            /// Save Button
        model.save()
      }, label: {
        Text("Save")
          .fontWeight(.bold)
          .frame(maxWidth: .infinity)
      })
      .disabled(!saveIsEnabled)
      .buttonStyle(.bordered)
    } /// - VStack
    .padding()
    .onChange(of: model.lastSavedPhotoID) {
      isDisplayingSavedMessage = true
    }
    .alert(
      "Message",
      isPresented: $isDisplayingSavedMessage,
      actions: { },
      message: {
        Text("Saved photo with id: \(model.lastSavedPhotoID)")
      }
    )
    .sheet(isPresented: $isDisplayingPhotoPicker, onDismiss: {
      
    }) {
      PhotosView().environmentObject(model)
    }
    .onAppear(perform: model.bindMainView)
    .onReceive(model.updateUISubject, perform: updateUI)
  }
  
  // MARK: - Helper methods
  func updateUI(photosCount: Int) {
    saveIsEnabled = photosCount > 0 && photosCount % 2 == 0
    clearIsEnabled = photosCount > 0
    addIsEnabled = photosCount < 6
    title = photosCount > 0 ? "\(photosCount) photos" : "Collage Neue"
  }
}

#Preview {
  ContentView()
    .environmentObject(CollageNeueModel())
}
