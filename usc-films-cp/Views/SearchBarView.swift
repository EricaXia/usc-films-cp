//
//  SearchView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI
import Kingfisher

struct SearchBarView: View {
    
    @Environment(\.openURL) var openURL
//    let movies = ["123", "Wonder woman", "Godzilla vs Kong", "Raya", "Minari", "Harry Potter and the chamber", "Harry Potter and the prisoner"]
    let debouncer = Debouncer(timeInterval: 0.6)
    
    @State private var searchText : String = ""
    @State var search_results = [SearchResult]()
    static var baseURL = "http://uscfilmsbackend-env.eba-gpz54xj7.us-east-2.elasticbeanstalk.com/apis/search/"
//    static var baseURL = "http://localhost:8080/apis/search/"
    
    init() {
//       UITableView.appearance().separatorStyle = .none
       UITableViewCell.appearance().backgroundColor = .white
       UITableView.appearance().backgroundColor = .white
    }
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                Text("Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.top, 20)
                SearchBar(text: $searchText, onTextChanged: searchResults, placeholder: "Search Movies, TVs...")
                    .padding(.top, -5.0)
                

                    List {
                        ForEach(self.search_results) {
                            movie in
                            ZStack() {
                                    KFImage(URL(string: movie.imgPath)!)
                                        .resizable()
                                        .frame(width: 350, height: 190) // 196
                                        .cornerRadius(15)
                                        .shadow(radius: 1)
                                VStack(alignment: .leading) {
                                    HStack {
                                        // MOVIE YEAR
                                        Text("\(movie.mediaTypeStr)\(movie.yearStr)".uppercased()).fontWeight(.bold).foregroundColor(Color.white)
                                        Spacer()
                                        // STAR RATING
                                        HStack {
                                            Image(systemName: "star.fill").foregroundColor(.red)
                                            Text("\(movie.starRatingStr)").fontWeight(.bold).foregroundColor(Color.white)
                                        } // HStack
                                    } // HStack
                                    .padding([.top, .leading, .trailing])
                                    Spacer()
                                    // MOVIE TITLE
                                    Text(movie.titleStr).fontWeight(.bold).foregroundColor(Color.white).padding([.leading, .bottom])
                                } // Vstack
                                    
                                } // Zstack
                        } // ForEach
                    } // List
                    .listStyle(PlainListStyle())
            
                
            } //Vstack
            
            // Removes white space above title
            .navigationBarTitle("")
            .navigationBarHidden(true)
        } // Navview
    } // body
    
    func getSearchResultsData(for searchText: String) {
        let urlString = "\(SearchBarView.baseURL)\(searchText)"
//        print("URLString:")
//        print(urlString)
        
        // encode URL to allow white space in search text
        let urlStringEncoded = urlString.replacingOccurrences(of: " ", with: "%20")
        print(urlStringEncoded)
        
        NetworkManager<SearchResponse>.fetchData(from: urlStringEncoded) { (result) in
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

