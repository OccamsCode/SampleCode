//
//  AsyncContentView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 22/11/2023.
//

import SwiftUI

protocol LoadableObject: ObservableObject {
    associatedtype Output
    nonisolated var phase: LoadingState<Output> { get }
    func load()
}

struct AsyncContentView<Source, LoadingView, Idle, Content>: View
    where Source: LoadableObject, LoadingView: View, Idle: View, Content: View {
    @ObservedObject var source: Source
    var loadingView: LoadingView
    var idle: Idle
    var content: (Source.Output) -> Content

    init(source: Source,
         loadingView: LoadingView,
         @ViewBuilder idle: () -> Idle,
         @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.loadingView = loadingView
        self.content = content
        self.idle = idle()
    }

    var body: some View {
        switch source.phase {
        case .idle:
            idle
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
    init(source: Source,
         @ViewBuilder idle: () -> Idle,
         @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.init(source: source,
                  loadingView: ProgressView(),
                  idle: idle,
                  content: content)
    }
}
