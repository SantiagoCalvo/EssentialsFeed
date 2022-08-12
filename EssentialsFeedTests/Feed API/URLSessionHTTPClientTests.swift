//
//  URLSessionHTTPClientTests.swift
//  EssentialsFeedTests
//
//  Created by santiago calvo on 11/08/22.
//

import XCTest

class URLSessionHTTPClient {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in }
    }
}

class URLSessionHTTPCLientTests: XCTestCase {
    
    func test_getFromURL_createsDatataksWithURL() {
        let url = URL(string: "http://a-url.com")!
        let session = URLSessionSpy()
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return fakeURLSessionDataTask()
        }
        
    }
    
    class fakeURLSessionDataTask: URLSessionDataTask {}
    
}
