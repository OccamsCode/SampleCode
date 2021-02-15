//
//  NewsClient.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

class NewsClient: APIClient {
    var session: URLSessionProtocol
    
    init(_ session: URLSessionProtocol) {
        self.session = session
    }
    
}
