//
//  Source.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/11/2023.
//

import Foundation

struct Source {
    let name: String
    let url: URL?
}

extension Source: Previewable {
    static var preview: Source {
        return Source(name: "CNN",
                      url: URL(string: "https://www.cnn.com"))
    }
}
