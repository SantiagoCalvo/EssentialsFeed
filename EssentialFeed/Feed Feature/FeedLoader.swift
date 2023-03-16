//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by santiago calvo on 11/03/23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
