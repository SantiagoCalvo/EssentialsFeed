//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by santiago calvo on 12/03/23.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURL, [])
    }
    
    func test_loadTwice_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(with: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURL, [url, url])
    }
    
    
    
    //MARK: - Helpers
    
    private func makeSUT(with url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPCLient {
        var requestedURL: [URL] = []
        
        func get(from url: URL) {
            self.requestedURL.append(url)
        }
    }

}
