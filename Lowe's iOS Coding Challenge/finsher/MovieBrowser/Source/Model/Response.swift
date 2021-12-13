//
//  Response.swift
//  MovieBrowser
//
//  Created by Nallamothu, Tharun on 12/12/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

// MARK: Search Movies API
struct Response: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let title: String
    let vote_average: Float
    let release_date: String
    let overview: String
    let poster_path: String
}

// MARK: Configurable API
struct Images: Codable {
    let base_url: String
}

public struct ImagesParent: Codable {
    var images: Images
}
