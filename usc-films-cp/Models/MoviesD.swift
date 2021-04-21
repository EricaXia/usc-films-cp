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
    
    var video_id: String?
    var genres_str: String?
    var star_rating: Double?
    var overview: String?
    
    struct CastMember: Codable, Identifiable {
        var id: Int? // NEED this in order to be identifiable type
        var name: String?
        var nameStr: String {
            guard let name = name else { return "" }
            return "\(name)"
        }
        var profile_path: String?
        var imgPath: String {
            guard let profile_path = profile_path else { return "" }
            return "https://image.tmdb.org/t/p/w500\(profile_path)"
        }
    }
    var cast: [CastMember]
    
    struct ReviewItem: Codable, Identifiable {
        var id: String?
        var author: String?
        var authorStr: String {
            guard let author = author else { return "" }
            return "\(author)"
        }
        var content: String?
        var contentStr: String {
            guard let content = content else { return "" }
            return "\(content)"
        }
        var review_date: String?
        var reviewDateStr: String {
            guard let review_date = review_date else { return "" }
            return "\(review_date)"
        }
        var star_rating: Double?
        var starRatingReviewStr: String {
            guard let star_rating = star_rating else { return "" }
            return "\(star_rating)"
        }
    }
    var reviews: [ReviewItem]
    
    var recs: [Movie]
    
    var mediaTypeStr: String {
        guard let media_type = media_type else { return "" }
        return "\(media_type)"
    }
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
    var genresStr: String {
        guard let genres_str = genres_str else { return "" }
        return "\(genres_str)"
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





