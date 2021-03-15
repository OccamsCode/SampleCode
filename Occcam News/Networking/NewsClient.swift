//
//  NewsClient.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

enum NewsCategory: String {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

enum NewsAPI {
    case topHeadlines(NewsCategory)
}

extension NewsAPI: Endpoint {
    
    var baseURL: String {
        return "newsapi.org"
    }
    
    var path: String {
        return "/v2/top-headlines"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var parameters: Parameters? {
        
        //TODO: Support regional news
        var params:Parameters = ["country":"gb", "pageSize":"10"]
        
        switch self {
        case .topHeadlines(let category):
            params.updateValue(category.rawValue, forKey: "category")
        }
        
        return params
    }
    
    var headers: HTTPHeaders {
        return ["Authorization":"e3452d72803f4632af9e317be1662d3b"]
    }
    
}

class NewsClient: APIClient {
    
    var parser: Parser
    var session: URLSessionProtocol
    
    init(_ session: URLSessionProtocol, jsonParser: Parser) {
        self.session = session
        self.parser = jsonParser
    }
    
}
