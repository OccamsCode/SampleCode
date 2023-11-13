//
//  NewsClient.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
import UIKit.UIImage
import Poppify
import Injection

class NewAPIClient: Client {
    @Injected(\.cacheProvider) var cache: Cache<URL, UIImage>
    @Injected(\.environmentProvider) var environment: EnvironmentType
    @Injected(\.sessionProvider) var urlSession: URLSessionType
}
