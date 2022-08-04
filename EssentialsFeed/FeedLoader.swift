//
//  FeedLoader.swift
//  EssentialsFeed
//
//  Created by santiago calvo on 3/08/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
