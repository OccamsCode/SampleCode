//
//  ArticleRowView.swift
//  AppTests
//
//  Created by Brian Munjoma on 15/11/2023.
//

import SwiftUI

struct ArticleRowView: View {

    enum Action {
        case onShare
        case onBookmark
    }

    let article: Article
    @ViewBuilder let bookmarkIcon: () -> Image
    let action: (ArticleRowView.Action) -> Void
    let relativeDateFormatter = RelativeDateTimeFormatter()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: article.image) { phase in
                switch phase {
                case .empty:
                        ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)

                case .failure:
                        Image(systemName: "photo")
                            .imageScale(.large)
                @unknown default:
                    fatalError()
                }
            }
            .asyncImageFrame(horizontalSizeClass ?? .compact)
            .background(Color.gray.opacity(0.3))
            .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                Text(article.description)
                    .font(.subheadline)
                    .lineLimit(2)

                if horizontalSizeClass == .regular {
                    Spacer()
                }

                HStack {
                    Text(articleInformationText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    Spacer()
                    Button { action(.onBookmark) } label: {
                        bookmarkIcon()
                    }
                    .buttonStyle(.bordered)

                    Button { action(.onShare) } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding([.horizontal, .bottom])
        }
    }

    var articleInformationText: String {
        let relativeTime = relativeDateFormatter.localizedString(for: article.publishedAt, relativeTo: .now)
        return "\(article.source.name) · \(relativeTime)"
    }
}

fileprivate extension View {

    @ViewBuilder
    func asyncImageFrame(_ horizontalSizeClass: UserInterfaceSizeClass) -> some View {
        switch horizontalSizeClass {
        case .regular:
            frame(maxWidth: .infinity, idealHeight: 200, maxHeight: 250)
        default:
            frame(maxWidth: .infinity, minHeight: 200, maxHeight: 300)
        }
    }

}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(article: .preview(),
                       bookmarkIcon: { Image(systemName: "bookmark.fill") },
                       action: { _ in })
    }
}
