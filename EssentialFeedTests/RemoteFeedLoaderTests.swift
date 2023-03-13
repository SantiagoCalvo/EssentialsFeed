//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by santiago calvo on 12/03/23.
//

import XCTest

class RemoteFeedLoader {
    
    let client: HTTPCLient
    let url: URL
    
    init(url: URL, client: HTTPCLient) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPCLient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPCLient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        self.requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let _ = RemoteFeedLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
}
