//
//  Requests.swift
//  Occcam News
//
//  Created by Brian Munjoma on 17/11/2023.
//

import Foundation
import Poppify

struct TopHeadlinesRequest: Requestable {
    let path: String = "/api/v4/top-headlines"
    let parameters: [URLQueryItem]

    init(_ category: NewsCategory = .general) {
        parameters = [
            URLQueryItem(name: "category", value: category.rawValue)
        ]
    }
}
