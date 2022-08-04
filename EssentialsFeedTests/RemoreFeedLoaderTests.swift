//
//  RemoreFeedLoaderTest.swift
//  EssentialsFeedTests
//
//  Created by santiago calvo on 3/08/22.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.getFrom(url: URL(string: "https://a-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func getFrom(url: URL) {}
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    override func getFrom(url: URL) {
        requestedURL = url
    }

}

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let _ = RemoteFeedLoader()
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader()
        HTTPClient.shared = client
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
