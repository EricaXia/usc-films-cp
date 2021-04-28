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
    
    let debouncer = Debouncer(timeInterval: 0.9)
    
    @State private var searchText : String = ""
    @State private var isSearching = false  // var to pass to SearchBar struct
    @State var search_results = [Movie]() // pass to SearchBar to clear results on cancel
    static var baseURL = "http://uscfilmsbackend-env.eba-gpz54xj7.us-east-2.elasticbeanstalk.com/apis/search/"
    //    static var baseURL = "http://localhost:8080/apis/search/"
    
    @State private var showNoResults = false
    
    init() {
        UITableViewCell.appearance().backgroundColor = .white
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .white
    }
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                
//                // For testing only - TODO delete later
//                Button ("[TESTING] Delete watchlist") {
//                    UserDefaults.standard.removeObject(forKey: "watchlist")
//                }
                
                Text("Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.top, 20)
                
                HStack {
                    SearchBar(search_results: $search_results, isSearching: $isSearching, showNoResults: $showNoResults, text: $searchText, onTextChanged: showSearchResults, placeholder: "Search Movies, TVs...")
                        .padding(.top, -5.0)
                } // Hstack
                
                Spacer()
                
                Group {
                    if (isSearching) {
                        if (self.search_results.count > 0) {
                            
                            VStack {
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
                            } // VStack
                            
                        } //end if count > 0
                        
                        VStack {
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
                                } // showNoResults
                            } // Vstack
                            .onAppear() {
                                
                                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                                    withAnimation {
                                        if (self.search_results.count == 0) {
                                            print("Timer triggered")
                                            self.showNoResults = true
                                        } // end if
                                    } // withAnimation
                                    } // timer
                                
                            } //onAppear
                    } // end if isSearching
                } // Group
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
            showNoResults = false
            debouncer.renewInterval()
            debouncer.handler = {
                isSearching = true
                self.getSearchResultsData(for: searchTextEntered)
            } // debouncer.handler
        } // if end
    } // func showSearchResults
} // SearchView struct

struct SearchBar: UIViewRepresentable {
    
    @Binding var search_results: Array<Movie>
    @Binding var isSearching: Bool
    @Binding var showNoResults: Bool
    @Binding var text: String
    var onTextChanged: (String) -> Void
    var placeholder: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var search_results: Array<Movie>
        @Binding var isSearching: Bool
        @Binding var showNoResults: Bool
        @State var searching = false
        
        var onTextChanged: (String) -> Void
        @Binding var text: String
        
        init(isSearching: Binding<Bool>, search_results:Binding<Array<Movie>>, showNoResults: Binding<Bool>, text: Binding<String>, onTextChanged: @escaping (String) -> Void) {
            _text = text
            _isSearching = isSearching
            _showNoResults = showNoResults
            _search_results = search_results
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
            searching = false
            isSearching = false
            showNoResults = false
            text = ""
            search_results.removeAll()  // clear results when cancel btn is clicked
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
        }
    
    } // Coordinator
    
    

    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(isSearching: $isSearching, search_results: $search_results, showNoResults: $showNoResults, text: $text, onTextChanged: onTextChanged)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.becomeFirstResponder() // show keyboard??
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
//        searchBar.becomeFirstResponder() // show keyboard??
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

