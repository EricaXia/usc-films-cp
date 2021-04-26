import Foundation

struct SearchResponse: Codable {
    var results: [SearchResult]
}

struct SearchResult: Codable, Identifiable, Hashable {
    var id: Int?
    var media_type: String?
    var title: String?
    var year: String?
    var star_rating: Double?
    var img_path: String?
    
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
