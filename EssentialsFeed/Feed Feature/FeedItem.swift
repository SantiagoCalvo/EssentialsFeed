//
//  FeedItem.swift
//  EssentialsFeed
//
//  Created by santiago calvo on 3/08/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
