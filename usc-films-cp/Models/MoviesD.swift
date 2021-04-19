//
//  MoviesD.swift
//  usc-films
//
//  Created by Erica Xia on 4/16/21.
//

import Foundation

struct MovieDetailsResponse: Codable {
    var results: [MovieD]
}

// structure for Detailed movie
struct MovieD: Codable, Identifiable {
    var id: Int?
    var title: String?
    var year: String?
    var poster_path: String?
    var PosterPath: String {
        if let path = poster_path {
            return "https://image.tmdb.org/t/p/w500/\(path)"
        } else {
            return ""
        }
    }
    
    var video_id: String?

//    struct Genre: Codable {
//        var name: String?
//    }
//    var genres: [Genre]

    var star_rating: Double?
    
    var overview: String?
    
//    struct CastMember: Codable {
//        var name: String?
//        var id: Int?
//        var img_path: String?
//    }
//
//    var cast: [CastMember]
    
//    struct ReviewItem: Codable {
//        var author: String?
//        var content: String?
//        var review_date: String?
//        var star_rating: Double?
//    }
    
    var videoIdStr: String {
        guard let video_id = video_id else { return "" }
        return "\(video_id)"
    }
    var idStr: String {
        guard let id = id else { return "" }
        return "\(id)"
    }
    var titleStr: String {
        guard let title = title else { return "" }
        return "\(title)"
    }
    var yearStr: String {
        guard let year = year else { return "" }
        return "\(year)"
    }
    var starRatingStr: String {
        guard let star_rating = star_rating else { return "" }
        return "\(star_rating)"
    }
    var overviewStr: String {
        guard let overview = overview else { return "" }
        return "\(overview)"
    }
    
    
    
    
}





