//
//  NewsClient.swift
//  Occcam News
//
//  Created by Brian Munjoma on 17/11/2023.
//

import Foundation
import Injection
import Poppify

final class NewsClient: Client {
    @Injected(\.environmentProvider) var environment: EnvironmentType
    @Injected(\.sessionProvider) var urlSession: URLSessionType
}
