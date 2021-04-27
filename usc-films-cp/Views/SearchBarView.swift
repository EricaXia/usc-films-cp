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
    
    let debouncer = Debouncer(timeInterval: 0.6)
    
    @State private var isSearching = false  // var to pass to SearchBar struct
    @State private var searchText : String = ""
    @State var search_results = [Movie]()
    static var baseURL = "http://uscfilmsbackend-env.eba-gpz54xj7.us-east-2.elasticbeanstalk.com/apis/search/"
    //    static var baseURL = "http://localhost:8080/apis/search/"
    
    @State var showNoResults = false
    
    init() {
        UITableViewCell.appearance().backgroundColor = .white
        UITableView.appearance().separatorStyle = .none
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
                    SearchBar(isSearching: $isSearching, text: $searchText, onTextChanged: showSearchResults, placeholder: "Search Movies, TVs...")
                        .padding(.top, -5.0)
                } // Hstack
                
                Spacer()
                
                Group {
                    if (isSearching) {
                        if (self.search_results.count > 0) {
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
                        } //end if count > 0
                        
                        else if (self.search_results.count == 0) {
                            if (showNoResults) {
                                HStack(alignment: .top) {
                                    Spacer()
                                    Text("No Results").foregroundColor(.gray).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).multilineTextAlignment(.center)
                                    Spacer()
                                }.padding(.bottom)
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                            }
                        } // end else if
                    } // end if isSearching
                } // Group
                
                // Prevents No Results msg from appearing too soon
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (_) in
                        withAnimation {
                            self.showNoResults = true
                        }
                    }
                } //onAppear
                
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
    
    func showSearchResults(for searchTextEntered: String) {
        if searchTextEntered.count >= 3 {
            debouncer.renewInterval()
            debouncer.handler = {
                isSearching = true
                self.getSearchResultsData(for: searchTextEntered)
            } // debouncer.handler
        } // if end
    } // func showSearchResults
} // SearchView struct

struct SearchBar: UIViewRepresentable {
    
    @Binding var isSearching: Bool
    @Binding var text: String
    var onTextChanged: (String) -> Void
    var placeholder: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var isSearching: Bool
        @State var searching = false
        
        var onTextChanged: (String) -> Void
        @Binding var text: String
        
        init(isSearching: Binding<Bool>, text: Binding<String>, onTextChanged: @escaping (String) -> Void) {
            _text = text
            _isSearching = isSearching
            self.onTextChanged = onTextChanged
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
            UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
            searching = true
            isSearching = true
            searchBar.showsCancelButton = true
            text = searchText
            onTextChanged(text)
        } // searchBar
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            print("Cancel btn clicked")
            searching = false
            isSearching = false
            text = ""
            //            searchBar.text = ""
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)

        }
    } // Coordinator
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(isSearching: $isSearching, text: $text, onTextChanged: onTextChanged)
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

