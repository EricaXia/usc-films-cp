//
//  SearchView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI

struct SearchView: View {
    let movies = ["123", "Wonder woman", "Godzilla vs Kong", "Raya", "Minari", "Harry Potter and the chamber", "Harry Potter and the prisoner"]
    @State private var searchText : String = ""
    @Environment(\.openURL) var openURL
    @ObservedObject var searchDownloader: SearchDownloader
    
    init() {
        self.searchDownloader = SearchDownloader(searchText: "")
    }
    
    var body: some View {
        
        
//        ScrollView {
        NavigationView {
            
            VStack(alignment: .leading) {
                Spacer()
                Text("Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.top, 20)
                
                //            HStack {
                //                TextField("Search Movies, TVs...", text: $searchText)
                //                    .padding([.top, .bottom, .trailing], 5)
                //                    .padding(.leading, 30)
                //                    .frame(height: 40.0)
                //                    .foregroundColor(Color(.systemGray2))
                //
                //            }
                //            .background(Color(.systemGray5))
                //            .cornerRadius(10)
                //            .padding(.horizontal, 8.0)
                //            .overlay(
                //                HStack {
                //                    Image(systemName: "magnifyingglass")
                //                        .foregroundColor(.gray)
                //                    Spacer()
                //                }
                //                .padding(.horizontal)
                //            )
                
                SearchBar(text: $searchText, placeholder: "Search Movies, TVs...")
                
                List {
                    ForEach(self.movies.filter {
                        self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
                    }, id: \.self) { movie in
                        Text(movie)
                    }
                } // List
                
            } //vstack
            
        } //scrollview
        
        
    } // body
    
    
    func searchResults(for searchText: String) {
        if !searchText.isEmpty {
            searchDownloader.getSearchResultsData(for: searchText)
        }
    }
    
} // SearchView struct

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    var placeholder: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
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
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
