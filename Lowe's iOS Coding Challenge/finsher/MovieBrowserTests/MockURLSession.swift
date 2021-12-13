//
//  MockURLSession.swift
//  MovieBrowserTests
//
//  Created by Nallamothu, Tharun on 12/12/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
@testable import MovieBrowser

class MockURLSession: URLSessionProtocol {
    private (set) var lastURLRequest: URLRequest?

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        lastURLRequest = request
        return URLSession.shared.dataTask(with: request)
    }
}
