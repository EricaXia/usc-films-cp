//
//  Movies.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import Foundation

struct MovieResponse: Codable {
    var results: [Movie]
}

struct Movie: Codable, Identifiable, Hashable {
    var id: Int?
    var media_type: String?
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
    // ADD from search results
    var star_rating: String?
    var img_path: String? // backdrop image
    
    var mediaTypeStr: String {
        guard let media_type = media_type else { return "" }
        return "\(media_type)"
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
        return "(\(year))"
    }
    var starRatingStr: String {
        guard let star_rating = star_rating else { return "" }
        return "\(star_rating)"
    }
    var imgPath: String {
        guard let img_path = img_path else { return "" }
        return "\(img_path)"
    }
    
}
