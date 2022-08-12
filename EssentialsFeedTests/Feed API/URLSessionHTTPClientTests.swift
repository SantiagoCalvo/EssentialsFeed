//
//  URLSessionHTTPClientTests.swift
//  EssentialsFeedTests
//
//  Created by santiago calvo on 11/08/22.
//

import XCTest
import EssentialsFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTaks
}

protocol HTTPSessionTaks {
    func resume()
}

class URLSessionHTTPClient {
    let session: HTTPSession
    
    init(session: HTTPSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPCLientTests: XCTestCase {
    
    func test_getFromURL_resumesDatataksWithURL() {
        let url = URL(string: "http://a-url.com")!
        let session = HTTPSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) {_ in}
        
        XCTAssertEqual(task.resumeCalls, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://a-url.com")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "any error", code: 1)
        session.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        let exp = expectation(description: "wait for completion")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("expected failure with error \(error), got result instead \(result)")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)

    }
    
    //MARK: - Helpers
    class HTTPSessionSpy: HTTPSession {
        var receivedURLs = [URL]()
        private var createdSessions = [URL: Stub]()
        
        private struct Stub {
            let task: HTTPSessionTaks
            let error: Error?
        }
        
        func stub(url: URL, task: HTTPSessionTaks = fakeURLSessionDataTask(), error: Error? = nil) {
            createdSessions[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTaks {
            receivedURLs.append(url)
            guard let stub = createdSessions[url] else {
                fatalError("could not find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
        
        
    }
    
    class fakeURLSessionDataTask: HTTPSessionTaks {
        func resume() {}
    }
    
    class URLSessionDataTaskSpy: HTTPSessionTaks {
        var resumeCalls = 0
        
        func resume() {
            resumeCalls += 1
        }
    }
    
}
