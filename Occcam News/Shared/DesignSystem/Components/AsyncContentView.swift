//
//  AsyncContentView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 22/11/2023.
//

import SwiftUI

protocol LoadableObject: ObservableObject {
    associatedtype Output
    var phase: LoadingState<Output> { get }
    func load()
}

struct AsyncContentView<Source: LoadableObject,
                            LoadingView: View,
                            Content: View>: View {
    @ObservedObject var source: Source
    var loadingView: LoadingView
    var content: (Source.Output) -> Content

    init(source: Source,
         loadingView: LoadingView,
         @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.loadingView = loadingView
        self.content = content
    }

    var body: some View {
        switch source.phase {
        case .idle:
            Color.clear
                .onAppear(perform: source.load)
        case .loading:
            loadingView
        case .failure(let error):
            ContentErrorView(title: "General Error",
                             message: error.localizedDescription,
                             actionTitle: "Retry",
                             callback: source.load)
        case .success(let output):
            content(output)
        }
    }
}

typealias DefaultProgressView = ProgressView<EmptyView, EmptyView>

extension AsyncContentView where LoadingView == DefaultProgressView {
    init(source: Source, @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.init(source: source,
                  loadingView: ProgressView(),
                  content: content)
    }
}
