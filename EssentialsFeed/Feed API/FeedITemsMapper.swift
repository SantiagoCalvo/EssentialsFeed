//
//  FeedITemsMapper.swift
//  EssentialsFeed
//
//  Created by santiago calvo on 9/08/22.
//

import Foundation

internal final class FeedITemsMapper {
    
    private static var OK_200: Int { return 200 }
    
    private struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            return items.map { $0.feedItem }
        }
    }

    private struct Item: Equatable, Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var feedItem: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }

        let items = root.feed
        return .success(items)
    }
}
