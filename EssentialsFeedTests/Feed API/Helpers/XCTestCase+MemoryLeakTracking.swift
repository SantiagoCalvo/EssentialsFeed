//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialsFeedTests
//
//  Created by santiago calvo on 13/08/22.
//

import XCTest

extension XCTestCase {
    /// check for potencial memory leaks on sut
    /// - Parameters:
    ///   - instance: sut or class to check for memory leaks
    ///   - file: file
    ///   - line: line
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been dealocated, potencial memory leak", file: file, line: line)
        }
    }

}
