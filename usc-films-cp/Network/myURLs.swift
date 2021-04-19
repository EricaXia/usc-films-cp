//
//  myURLs.swift
//  usc-films
//
//  Created by Erica Xia on 4/13/21.
//

import Foundation

enum myURLs: String {

    case nowPlaying = "now_playing"
    case topRated_movies = "movie/top_rated"
    case popular_movies = "movie/popular"
    case airingToday = "airing_today"
    case topRated_tv = "tv/top_rated"
    case popular_tv = "tv/popular"
    
    public var urlStr: String {
        "\(Downloader.baseURL)\(self.rawValue)"
    }
    
    
    // for Details page
    
//    public var movieURLStr: String {
//        "\(Downloader.baseURL)/movie\(self.rawValue)"
//    }
//
//    public var tvURLStr: String {
//        "\(Downloader.baseURL)/tv/\(self.rawValue)"
//    }
    
}
