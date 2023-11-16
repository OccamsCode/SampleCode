//
//  SafariView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 16/11/2023.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> some SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
