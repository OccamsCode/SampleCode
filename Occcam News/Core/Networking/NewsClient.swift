//
//  NewsClient.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
import UIKit

class NewAPIClient: Client {

    @Inject(\.cacheProvider) var cache: Cache<URL, UIImage>
    @Inject(\.environmentProvider) var environment: EnvironmentType
    @Inject(\.sessionProvider) var urlSession: URLSessionType
}
