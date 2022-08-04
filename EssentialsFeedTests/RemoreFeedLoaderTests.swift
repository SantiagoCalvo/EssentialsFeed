//
//  RemoreFeedLoaderTest.swift
//  EssentialsFeedTests
//
//  Created by santiago calvo on 3/08/22.
//

import XCTest

class RemoteFeedLoader {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.getFrom(url: URL(string: "https://a-url.com")!)
    }
}

protocol HTTPClient {
    func getFrom(url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    func getFrom(url: URL) {
        requestedURL = url
    }

}

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
