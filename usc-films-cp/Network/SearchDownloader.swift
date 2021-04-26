//
//  SearchDownloader.swift
//  usc-films
//
//  Created by Erica Xia on 4/26/21.
//

import SwiftUI

final class SearchDownloader: ObservableObject{

    @Published var search_results = [SearchResult]()
    
    private var searchText: String = ""
//    static var baseURL = "http://localhost:8080/apis/search/"
    static var baseURL = "http://uscfilmsbackend-env.eba-gpz54xj7.us-east-2.elasticbeanstalk.com/apis/search/"
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    func getSearchResultsData(for searchText: String) {
        let urlString = "\(Self.baseURL)\(self.searchText)"
        print("URLString:")
        print(urlString)
        NetworkManager<SearchResponse>.fetchData(from: urlString) { (result) in
            switch result {
            case .success(let searchResponse):
                self.search_results = searchResponse.results
                print(self.search_results)
            case .failure(let err):
                print(err)
            }
        }
        
    } // func end
}
