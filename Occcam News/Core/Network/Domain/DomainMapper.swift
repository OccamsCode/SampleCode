//
//  DomainMapper.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/11/2023.
//

import Foundation

enum DomainMapper {
    static func map(_ remoteModel: RemoteSource) -> Source {
        return Source(name: remoteModel.name,
                      url: URL(string: remoteModel.url))
    }
}
