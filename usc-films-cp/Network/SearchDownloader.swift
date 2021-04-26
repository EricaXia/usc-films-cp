//
//  SearchDownloader.swift
//  usc-films
//
//  Created by Erica Xia on 4/26/21.
//

import SwiftUI

final class SearchDownloader: ObservableObject{
    
    @Published var movieD = [MovieD]()
    
    private var searchText: String
//    static var baseURL = "http://localhost:8080/apis/watch/"
    static var baseURL = "http://uscfilmsbackend-env.eba-gpz54xj7.us-east-2.elasticbeanstalk.com/apis/search/"
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
//    func getSearchResults() {
//        print("Get Search Results from backend")
//        getSearchResultsData(for: searchText)
//    }

    func getSearchResultsData(for searchText: String) {
        let urlString = "\(Self.baseURL)/\(self.searchText)"
        print("URLString:")
        print(urlString)
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
