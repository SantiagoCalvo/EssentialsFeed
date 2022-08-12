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
        session.dataTask(with: url) { _, _, _ in }.resume()
    }
}

class URLSessionHTTPCLientTests: XCTestCase {
    
    func test_getFromURL_resumesDatataksWithURL() {
        let url = URL(string: "http://a-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        
        XCTAssertEqual(task.resumeCalls, 1)
    }
    
    class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()
        var createdSessions = [URL: URLSessionDataTask]()
        
        func stub(url: URL, task: URLSessionDataTask) {
            createdSessions[url] = task
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return createdSessions[url] ?? fakeURLSessionDataTask()
        }
        
        
    }
    
    class fakeURLSessionDataTask: URLSessionDataTask {}
    
    class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCalls = 0
        
        override func resume() {
            resumeCalls += 1
        }
    }
    
}
