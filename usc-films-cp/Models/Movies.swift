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

struct Movie: Codable, Identifiable {
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
    
}
