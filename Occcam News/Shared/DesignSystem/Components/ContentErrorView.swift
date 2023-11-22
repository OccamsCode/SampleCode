//
//  ContentErrorView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 21/11/2023.
//

import SwiftUI

struct ContentErrorView: View {
    let title: String
    let message: String
    var actionTitle: String?
    var callback: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 5) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            if let callback {
                Button(actionTitle ?? "Retry", action: callback)
            }
        }
        .padding(64)
        .multilineTextAlignment(.center)
    }
}

struct ContentErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentErrorView(title: "Connection Issue", message: "Check your internet connection")
            .previewDisplayName("No Action")

        ContentErrorView(title: "Connection Issue",
                  message: "Check your internet connection",
                  actionTitle: "Try Again",
                  callback: {})
            .previewDisplayName("With Action")
    }
}
