//
//  HTTPCLient.swift
//  EssentialFeed
//
//  Created by santiago calvo on 14/03/23.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
