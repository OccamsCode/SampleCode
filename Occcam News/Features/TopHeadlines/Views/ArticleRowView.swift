//
//  ArticleRowView.swift
//  AppTests
//
//  Created by Brian Munjoma on 15/11/2023.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    let relativeDateFormatter = RelativeDateTimeFormatter()

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
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 300)
            .background(Color.gray.opacity(0.3))
            .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                Text(article.description)
                    .font(.subheadline)
                    .lineLimit(2)

                HStack {
                    Text(articleInformationText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    Spacer()
                    Button {} label: {
                        Image(systemName: "bookmark")
                    }
                    .buttonStyle(.bordered)

                    Button {} label: {
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

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(article: .preview)
    }
}
