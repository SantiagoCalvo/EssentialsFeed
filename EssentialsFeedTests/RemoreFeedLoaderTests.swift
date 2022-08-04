//
//  RemoreFeedLoaderTest.swift
//  EssentialsFeedTests
//
//  Created by santiago calvo on 3/08/22.
//

import XCTest

class RemoteFeedLoader {
    
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.getFrom(url: url)
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
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        sut.load()
        
        XCTAssertEqual(url, client.requestedURL)
    }
}
