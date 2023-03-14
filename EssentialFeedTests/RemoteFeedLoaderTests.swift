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
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(with: url)
        
        sut.load {_ in}
        
        XCTAssertEqual(client.requestedURLs, [url])
    }

    
    func test_loadTwice_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(with: url)
        
        sut.load {_ in}
        sut.load {_ in}
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(with: url)
        
        let clientError = NSError(domain: "test", code: 0)
        expect(sut, toCompleteWithResult: .failure(.connectivity)) {
            client.complete(with: clientError)
        }
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(with: url)
                
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            
            expect(sut, toCompleteWithResult: .failure(.invalidData)) {
                client.complete(withStatusCode: code, at: index)
            }

        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        let invalidJSON = Data("invalid json".utf8)
        
        expect(sut, toCompleteWithResult: .failure(.invalidData)) {
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyList() {
        let (sut, client) = makeSUT()

        let emptyListJSON = Data("{\"items\": []}".utf8)
        
        expect(sut, toCompleteWithResult: .success([])) {
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }

    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = FeedItem(id: UUID(),
                    description: nil,
                    location: nil,
                    imageURL: URL(string: "https://any-image-url.com")!)
        
        let item1JSON = [
            "id": item1.id.uuidString,
            "image": item1.imageURL.absoluteString
        ]

        let item2 = FeedItem(id: UUID(),
                    description: "any description",
                    location: "any location",
                    imageURL: URL(string: "https://another-image-url.com")!)
        
        let item2JSON = [
            "id": item2.id.uuidString,
            "description": item2.description,
            "location": item2.location,
            "image": item2.imageURL.absoluteString
        ]
        
        let itemsJSON = [
            "items": [item1JSON, item2JSON]
        ]
        
        let feedItems = [item1, item2]
        
        expect(sut, toCompleteWithResult: .success(feedItems)) {
            let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    //MARK: - Helpers
    
    private func makeSUT(with url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithResult result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
        
    }
    
    private class HTTPClientSpy: HTTPCLient {
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success(data, response))
        }
    }

}
