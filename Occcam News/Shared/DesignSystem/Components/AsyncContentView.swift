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

struct AsyncContentView<Source: LoadableObject, Content: View>: View {
    @ObservedObject var source: Source
    var content: (Source.Output) -> Content

    init(source: Source, @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.content = content
    }

    var body: some View {
        switch source.phase {
        case .idle:
            Color.clear
                .onAppear(perform: source.load)
        case .loading:
            ProgressView()
        case .failure(let error):
            ContentErrorView(title: "Title",
                             message: error.localizedDescription,
                             actionTitle: "Retry",
                             callback: source.load)
        case .success(let output):
            content(output)
        }
    }
}
