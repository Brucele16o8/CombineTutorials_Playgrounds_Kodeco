//
//  TimeBadge.swift
//  HackerNewsReader
//
//  Created by Tung Le on 30/7/2025.
//

import SwiftUI

struct TimeBadge: View {
  private static var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
  }()
  
  let time: TimeInterval
    
  var body: some View {
    Text(TimeBadge.formatter.string(from: Date(timeIntervalSince1970: time)))
      .font(.headline)
      .fontWeight(.heavy)
      .padding(10)
      .foregroundStyle(Color.white)
      .background(Color.orange)
      .cornerRadius(10)
      .frame(idealWidth: 100)
      .padding(.bottom, 10)
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  TimeBadge(time: Date().timeIntervalSince1970)
}
