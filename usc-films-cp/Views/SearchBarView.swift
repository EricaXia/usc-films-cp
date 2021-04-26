//
//  SearchView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI

struct SearchBarView: View {
    
    @Environment(\.openURL) var openURL
    let movies = ["123", "Wonder woman", "Godzilla vs Kong", "Raya", "Minari", "Harry Potter and the chamber", "Harry Potter and the prisoner"]
    let debouncer = Debouncer(timeInterval: 1.0)
    
    @State private var searchText : String = ""
    @State var search_results = [SearchResult]()
    static var baseURL = "http://uscfilmsbackend-env.eba-gpz54xj7.us-east-2.elasticbeanstalk.com/apis/search/"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
//                Spacer()
                Text("Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.top, 20)
                
                SearchBar(text: $searchText, onTextChanged: searchResults, placeholder: "Search Movies, TVs...")
                
//                List {
//                    ForEach(self.movies.filter {
//                        self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
//                    }, id: \.self) { movie in
//                        Text(movie)
//                    }
//                } // List
                
                
                List {
                    ForEach(self.search_results) {
                        movie in
                            VStack {
                                Text(movie.idStr)
                                Text(movie.mediaTypeStr)
                                Text(movie.titleStr)
                                Text(movie.yearStr)
                                Text(movie.starRatingStr)
                            } // Vstack
                    }
                }
                
            } //vstack
            
        } // Navview
    } // body
    
    func getSearchResultsData(for searchText: String) {
        let urlString = "\(SearchBarView.baseURL)\(searchText)"
        print("URLString:")
        print(urlString)
        NetworkManager<SearchResponse>.fetchData(from: urlString) { (result) in
            switch result {
            case .success(let searchResponse):
                self.search_results = searchResponse.results
                print(search_results)
            case .failure(let err):
                print(err)
            }
        }
        
    } // func end
    
    func searchResults(for searchTextEntered: String) {
        if searchTextEntered.count >= 3 {
            
//            print("Search Text Entered")
//            print(searchTextEntered)
            
            debouncer.renewInterval()
//            print("renew interval")
            
            debouncer.handler = {
                self.getSearchResultsData(for: searchTextEntered)
//                print("method executed")
            } // debouncer.handler
            
        } // if
    } // func searchResults
    
} // SearchView struct

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    var onTextChanged: (String) -> Void
    var placeholder: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var onTextChanged: (String) -> Void
        @Binding var text: String
        
        init(text: Binding<String>, onTextChanged: @escaping (String) -> Void) {
            _text = text
            self.onTextChanged = onTextChanged
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            onTextChanged(text)
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, onTextChanged: onTextChanged)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
} // SearchBar

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}

