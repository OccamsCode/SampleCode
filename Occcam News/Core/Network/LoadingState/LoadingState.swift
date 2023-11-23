//
//  LoadingState.swift
//  Occcam News
//
//  Created by Brian Munjoma on 20/11/2023.
//

import Foundation

enum LoadingState<T> {
    case idle
    case loading
    case success(T)
    case failure(Error)
}
