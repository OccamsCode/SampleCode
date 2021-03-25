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
    case topHeadlines(api:NewsCategory, page: Int, pageSize: Int)
    case search(term: String, page: Int, pageSize: Int)
}

extension NewsAPI: Endpoint {
    
    var baseURL: String {
        return "newsapi.org"
    }
    
    var path: String {
        switch self {
        case .topHeadlines(_, _, _):
            return "/v2/top-headlines"
        case .search(_, _, _):
            return "/v2/everything"
        }
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var parameters: Parameters? {
        
        var params:Parameters = [:]
        
        switch self {
        case .topHeadlines(let category, let page, let pageSize):
            
            //TODO: Support regional news
            params.updateValue("gb", forKey: "country")
            params.updateValue(category.rawValue, forKey: "category")
            params.updateValue(String(page), forKey: "page")
            params.updateValue(String(pageSize), forKey: "pageSize")
            
        case .search(let searchTerm, let page, let pageSize):
            params.updateValue(searchTerm, forKey: "q")
            params.updateValue(String(page), forKey: "page")
            params.updateValue(String(pageSize), forKey: "pageSize")
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
