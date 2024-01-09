//
//  BPContentUnavailableView.swift
//  Occcam News
//
//  Created by Brian Munjoma on 09/01/2024.
//

import SwiftUI

@available(iOS, deprecated: 17.0, message: "Use SwiftUI's ContentUnavailableView API beyond iOS 16")
public struct ContentUnavailableView<Label, Description, Actions>: View
    where Label: View, Description: View, Actions: View {

    private let label: Label
    private let description: Description
    private let actions: Actions
    /// Creates an interface, consisting of a label and additional content, that you
    /// display when the content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///   - label: The label that describes the view.
    ///   - description: The view that describes the interface.
    ///   - actions: The content of the interface actions.
    public init(@ViewBuilder label: () -> Label,
                @ViewBuilder description: () -> Description = { EmptyView() },
                @ViewBuilder actions: () -> Actions = { EmptyView() }) {
        self.label = label()
        self.description = description()
        self.actions = actions()
    }

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SwiftUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    @MainActor public var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 8) {
                label
                    .labelStyle(AdaptiveLabelStyle())
                description
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            actions
        }
        .padding(.horizontal)
    }
}

struct AdaptiveLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 10) {
            configuration.icon
                .imageScale(.large)
                .scaleEffect(3.0, anchor: .bottom)
                .foregroundStyle(Color.gray)
            configuration.title
                .font(.title2.weight(.bold))
        }
        .padding(.horizontal)
    }
}

typealias DefaultLabel = Label<Text, Image>
extension ContentUnavailableView where Label == DefaultLabel, Description == Text?, Actions == EmptyView {

    /// Creates an interface, consisting of a title generated from a localized
    /// string, an image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    init(_ title: LocalizedStringKey, image name: String, description: Text? = nil) {
        self.init {
            Label(title, image: name)
        } description: {
            description
        }
    }

    /// Creates an interface, consisting of a title generated from a localized
    /// string, a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    init(_ title: LocalizedStringKey, systemImage name: String, description: Text? = nil) {
        self.init {
            Label(title, systemImage: name)
        } description: {
            description
        }
    }

    /// Creates an interface, consisting of a title generated from a string,
    /// an image and additional content, that you display when the content of
    /// your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    init<S>(_ title: S, image name: String, description: Text? = nil) where S: StringProtocol {
        self.init {
            Label(title, image: name)
        } description: {
            description
        }
    }

    /// Creates an interface, consisting of a title generated from a string,
    /// a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    init<S>(_ title: S, systemImage name: String, description: Text? = nil) where S: StringProtocol {
        self.init {
            Label(title, systemImage: name)
        } description: {
            description
        }
    }
}

struct ContentUnavailableView_Previews: PreviewProvider {
    static var previews: some View {
        ContentUnavailableView("Some",
                               systemImage: "globe")
        .previewDisplayName("Label")

        ContentUnavailableView("Some",
                               systemImage: "globe",
                               description: Text("Check your internet connection"))
        .previewDisplayName("Label w/ Description")

        ContentUnavailableView {
            Label("Empty Bookmarks", systemImage: "bookmark")
        } description: {
            Text("Explore a great movie and bookmark the one you love to enjoy later.")
        } actions: {
            // 2
            Button("Browse Movies") {}
            .buttonStyle(.borderedProminent)
        }
        .previewDisplayName("Label w/ Description + Action")
    }
}
