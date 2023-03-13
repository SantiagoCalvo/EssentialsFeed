//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by santiago calvo on 12/03/23.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPCLient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPCLient()
        let _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
}
