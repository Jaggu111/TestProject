//
//  Network.swift
//  MovieBrowser
//
//  Created by Struzinski, Mark on 12/12/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.

import UIKit

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}


class Network {

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }


    let apiKey = "5885c445eab51c7004916b9c0313e2d3"

    func fetchSearchesFromAPI(searchString: String, completion: @escaping ((Result<Response?, Error>) -> Void)) {

        let queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "query", value: searchString)]
        var urlComps = URLComponents(string: "https://api.themoviedb.org/3/search/movie")!
        
        urlComps.queryItems = queryItems
        urlComps.percentEncodedQuery = urlComps.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        let request = URLRequest(url: urlComps.url!)

        let task = session.dataTask(with: request) { data, _, error in
            // Check if an error occurred
            if let error = error {
                // HERE you can manage the error
                completion(Result.failure(error))
                return
            }

            // Serialize the data into an object
            do {
                let json = try JSONDecoder().decode(Response.self, from: data!)
                print(json)

                completion(Result.success((json)))
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func fetchBaseURL(completion: @escaping ((Result<ImagesParent?, Error>) -> Void)) {
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        var urlComps = URLComponents(string: "https://api.themoviedb.org/3/configuration")!

        urlComps.queryItems = queryItems
        urlComps.percentEncodedQuery = urlComps.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        let request = URLRequest(url: urlComps.url!)

        let task = session.dataTask(with: request) { data, _, error in
            // Check if an error occurred
            if let error = error {
                // HERE you can manage the error
                completion(Result.failure(error))
                return
            }

            // Serialize the data into an object
            do {
                let json = try JSONDecoder().decode(ImagesParent.self, from: data!)
                completion(Result.success((json)))
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func fetchImage(path: String, completion: @escaping ((Result<ImagesParent?, Error>) -> Void)) {

        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        var urlComps = URLComponents(string: "https://api.themoviedb.org/3/configuration")!

        urlComps.queryItems = queryItems
        urlComps.percentEncodedQuery = urlComps.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        let request = URLRequest(url: urlComps.url!)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            // Check if an error occurred
            if let error = error {
                // HERE you can manage the error
                completion(Result.failure(error))
                return
            }

            // Serialize the data into an object
            do {
                let json = try JSONDecoder().decode(ImagesParent.self, from: data!)
                completion(Result.success((json)))
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
