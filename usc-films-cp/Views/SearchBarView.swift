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
    
    let debouncer = Debouncer(timeInterval: 0.5)
    
    
    @State private var searchText : String = ""
    @State var search_results = [Movie]()
    static var baseURL = "http://uscfilmsbackend-env.eba-gpz54xj7.us-east-2.elasticbeanstalk.com/apis/search/"
    //    static var baseURL = "http://localhost:8080/apis/search/"
    
    init() {
        UITableViewCell.appearance().backgroundColor = .white
        UITableView.appearance().backgroundColor = .white
    }
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                
                // For testing only - TODO delete later
                Button ("[TESTING] Delete watchlist") {
                    UserDefaults.standard.removeObject(forKey: "watchlist")
                }
                
                Text("Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.top, 20)
                
                HStack {
                    
                    SearchBar(text: $searchText, onTextChanged: searchResults, placeholder: "Search Movies, TVs...")
                        .padding(.top, -5.0)
                    
                    
                } // Hstack
                
                
                
                
                List {
                    ForEach(self.search_results) {
                        movie in
                        NavigationLink(destination: DetailsView(movie: movie)){
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
                            } // Nav Link
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
        
        // encode URL to allow white space in search text
        let urlStringEncoded = urlString.replacingOccurrences(of: " ", with: "%20")
        print(urlStringEncoded)
        
        NetworkManager<MovieResponse>.fetchData(from: urlStringEncoded) { (result) in
            switch result {
            case .success(let searchResponse):
                self.search_results = searchResponse.results
            //                print(search_results)
            case .failure(let err):
                print(err)
            }
        }
    } // func end
    
    func searchResults(for searchTextEntered: String) {
        if searchTextEntered.count >= 3 {
            debouncer.renewInterval()
            debouncer.handler = {
                self.getSearchResultsData(for: searchTextEntered)
            } // debouncer.handler
        } // if end
    } // func searchResults
} // SearchView struct

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    var onTextChanged: (String) -> Void
    var placeholder: String
    
//    let searchController = UISearchController(searchResultsController: nil)
//    var isSearchBarEmpty: Bool {
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
//    @State var searching = false
    
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @State var searching = false
        
        var onTextChanged: (String) -> Void
        @Binding var text: String
        
        init(text: Binding<String>, onTextChanged: @escaping (String) -> Void) {
            _text = text
            self.onTextChanged = onTextChanged
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
            UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
            searching = true
            searchBar.showsCancelButton = true
//            tableView.reloadData()
            
            text = searchText
            onTextChanged(text)
            
        } // searchBar
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searching = false
    //        searchBar.text = nil
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
            searchBar.text = ""
    //        tableView.reloadData()
        }
    } // Coordinator
    

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
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

