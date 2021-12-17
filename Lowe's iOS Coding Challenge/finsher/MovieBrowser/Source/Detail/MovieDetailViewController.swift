//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    var filePath: String = ""
    var baseURL: String = ""
    let imageCache = NSCache<AnyObject, AnyObject>()
    let activityIndicator = UIActivityIndicatorView()
    var imageURL: URL?

    var movie: Movie? {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        configureView()
    }

    func loadImage() {
        if let url = URL(string: baseURL + "/w500" + filePath) {
            // setup activityIndicator...
            activityIndicator.color = .darkGray

            movieImageView.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: movieImageView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor).isActive = true

            imageURL = url

            movieImageView.image  = nil
            activityIndicator.startAnimating()

            // retrieves image if already available in cache
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

                self.movieImageView.image = imageFromCache
                activityIndicator.stopAnimating()
                return
            }

            downloadImage(from: url)
        }
    }

    func configureView() {
        if let movie = movie, let detailDescriptionLabel = detailDescriptionLabel, let releaseDateLabel = releaseDateLabel {
            filePath = movie.poster_path

            releaseDateLabel.text = movie.release_date
            detailDescriptionLabel.text = movie.overview
            movieTitleLabel.text = movie.title
            loadImage()
        }
    }

    // MARK: load Image from url data
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                if let imageToCache = UIImage(data: data) {

                    if self?.imageURL == url {
                        self?.movieImageView.image = imageToCache
                    }

                    self?.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
