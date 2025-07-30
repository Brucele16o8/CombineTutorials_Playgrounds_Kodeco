//
//  AddKeywordView.swift
//  HackerNewsReader
//
//  Created by Tung Le on 31/7/2025.
//

import SwiftUI

struct AddKeywordView: View {
  @State var newKeyword = ""
  
  let completed: (String) -> Void
  
  var body: some View {
    VStack(spacing: 50) {
      Text("New Keyword")
        .font(.largeTitle)
        .padding(.top, 40)
      
      TextField("Title", text: $newKeyword)
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray, lineWidth: 2)
        }
        .padding()
      
      LargeInlineButton(title: "Add keyword") {
        guard !self.newKeyword.isEmpty else { return }
        self.completed(self.newKeyword)
        self.newKeyword = ""
      }
      
      Spacer()
    } /// - VStack
  }
}


#Preview {
  AddKeywordView(
    newKeyword: "testing",
    completed: { _ in }
  )
}
