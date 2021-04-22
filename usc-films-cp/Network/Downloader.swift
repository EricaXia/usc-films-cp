//
//  Downloader.swift
//  usc-films
//
//  Created by Erica Xia on 4/13/21.
//

import SwiftUI
//import SwiftyJSON

final class Downloader: ObservableObject{
    @Published var movies = [Movie]()
    @Published var movies_toprated = [Movie]()
    @Published var movies_popular = [Movie]()
    
    @Published var tvshows = [Movie]()
    @Published var tvshows_toprated = [Movie]()
    @Published var tvshows_popular = [Movie]()
    
    // Details View for one movie
    @Published var movieD = [MovieD]()
//    @Published var cast = [CastMember]()
    
//    static var baseURL = "http://localhost:8080/apis/"
    static var baseURL = "http://uscfilmsbackend-env.eba-gpz54xj7.us-east-2.elasticbeanstalk.com/apis/"
    
    func getNowPlaying() {
        getData(myurls: .nowPlaying)
    }

    func getPopularMovies() {
        getData(myurls: .popular_movies)
    }

    func getTopRatedMovies() {
        getData(myurls: .topRated_movies)
    }
    
    func getAiringToday() {
        getData(myurls: .airingToday)
    }

    func getPopularTv() {
        getData(myurls: .popular_tv)
    }

    func getTopRatedTv() {
        getData(myurls: .topRated_tv)
    }
        
    private func getData(myurls: myURLs) {
        NetworkManager<MovieResponse>.fetchData(from: myurls.urlStr) { (result) in
            switch result {
            case .success(let movieResponse):
                if myurls == .nowPlaying {
                    self.movies = movieResponse.results
                } else if myurls == .popular_movies {
                    self.movies_popular = movieResponse.results
                } else if myurls == .topRated_movies {
                    self.movies_toprated = movieResponse.results
                } else if myurls == .airingToday {
                    self.tvshows = movieResponse.results
                } else if myurls == .popular_tv {
                    self.tvshows_popular = movieResponse.results
                } else if myurls == .topRated_tv {
                    self.tvshows_toprated = movieResponse.results
                } else {
                    print("error downloading")
                }
                
            case .failure(let err):
                print(err)
            }
        }
        
    }
}
