//
//  RemoreFeedLoaderTest.swift
//  EssentialsFeedTests
//
//  Created by santiago calvo on 3/08/22.
//

import XCTest
import EssentialsFeed


class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(url, client.requestedURL)
    }
    
    func test_load_requestsDataOnlyOnceFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLCallCount, 2)
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
        return (remoteFeedLoader, client)
    }
    private class HTTPClientSpy: HTTPClient {
        var requestedURLCallCount = 0
        var requestedURLs = [URL]()
        var requestedURL: URL?
        func get(from url: URL) {
            requestedURL = url
            requestedURLCallCount += 1
            requestedURLs.append(url)
        }
    }
}
