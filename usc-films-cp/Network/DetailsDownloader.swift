//
//  Downloader.swift
//  usc-films
//
//  Created by Erica Xia on 4/13/21.
//

import SwiftUI

final class DetailsDownloader: ObservableObject{
    @Published var movieD = [MovieD]()
    
    private var movie: Movie
//    static var baseURL = "http://localhost:8080/apis/watch/"
    static var baseURL = "http://uscfilmsbackend-env.eba-gpz54xj7.us-east-2.elasticbeanstalk.com/apis/watch/"
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func getMovieDetails() {
        print("Get Movie Details")
        getMovieDetailsData(for: movie)
        
    }
    
    func getTVShowDetails() {
        print("get tv show deets")
    }

    private func getMovieDetailsData(for movie: Movie) {
        let urlString = "\(Self.baseURL)\(movie.mediaTypeStr)/\(movie.idStr)"
//        print(urlString)
        NetworkManager<MovieDetailsResponse>.fetchData(from: urlString) { (result) in
            switch result {
            case .success(let movieDetailsResponse):
                self.movieD = movieDetailsResponse.results
//                 print(self.movieD) //WORKS here
            case .failure(let err):
                print(err)
            }
        }
        
    }
}
