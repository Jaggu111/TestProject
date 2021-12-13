//
//  NetworkTests.swift
//  MovieBrowserTests
//
//  Created by Nallamothu, Tharun on 12/12/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
@testable import MovieBrowser
import XCTest

class NetworkTests: XCTestCase {
    var subject: Network!
    let session = MockURLSession()

    override func setUp() {
        super.setUp()
        subject = Network(session: session)
    }

    func test_GET_RequestsTheURL() {
        let queryItems = [URLQueryItem(name: "api_key", value: "5885c445eab51c7004916b9c0313e2d3"), URLQueryItem(name: "query", value: "sr")]
        var urlComps = URLComponents(string: "https://api.themoviedb.org/3/search/movie")!

        urlComps.queryItems = queryItems
        urlComps.percentEncodedQuery = urlComps.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        let request = URLRequest(url: urlComps.url!)

        subject.fetchSearchesFromAPI(searchString: "sr") { (_) -> Void in }

        XCTAssertEqual(session.lastURLRequest, request)
    }
}
