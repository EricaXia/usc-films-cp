////
////  SearchView.swift
////  usc-films
////
////  Created by Erica Xia on 4/12/21.
////
//
//import SwiftUI
//
//struct SearchView: View {
//    
//    let movies = ["123", "Wonder woman", "Godzilla vs Kong", "Raya", "Minari", "Harry Potter and the chamber", "Harry Potter and the prisoner"]
//    let debouncer = Debouncer(timeInterval: 10.0)
//    @State private var searchText : String = ""
//    @Environment(\.openURL) var openURL
//    @ObservedObject var searchDownloader = SearchDownloader()
//    
//    
//    var body: some View {
//        
//        NavigationView {
//            
//            VStack(alignment: .leading) {
//                Spacer()
//                Text("Search")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding(.leading)
//                    .padding(.top, 20)
//                
//                SearchBar(text: $searchText, onTextChanged: searchResults, placeholder: "Search Movies, TVs...")
//                
//                List {
//                    ForEach(self.movies.filter {
//                        self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
//                    }, id: \.self) { movie in
//                        Text(movie)
//                    }
//                } // List
//                
//            } //vstack
//            
//        } // Navview
//        
//        
//    } // body
//    
//    func searchResults(for searchTextEntered: String) {
//        if searchTextEntered.count >= 3 {
//            print(searchTextEntered)
//            //            searchDownloader.getSearchResultsData(for: searchText)
//            
//            debouncer.renewInterval()
//            print("renew interval")
//            debouncer.handler = {
//                searchDownloader.getSearchResultsData(for: searchTextEntered)
//                print("method executed")
//            }
//            
//        } // if
//    } // func searchResults
//    
//} // SearchView struct
//
//struct SearchBar: UIViewRepresentable {
//    
//    @Binding var text: String
//    var onTextChanged: (String) -> Void
//    var placeholder: String
//    
//    class Coordinator: NSObject, UISearchBarDelegate {
//        var onTextChanged: (String) -> Void
//        @Binding var text: String
//        
//        init(text: Binding<String>, onTextChanged: @escaping (String) -> Void) {
//            _text = text
//            self.onTextChanged = onTextChanged
//        }
//        
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            text = searchText
//            onTextChanged(text)
//        }
//    }
//    
//    func makeCoordinator() -> SearchBar.Coordinator {
//        return Coordinator(text: $text, onTextChanged: onTextChanged)
//    }
//    
//    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
//        let searchBar = UISearchBar(frame: .zero)
//        searchBar.delegate = context.coordinator
//        searchBar.placeholder = placeholder
//        searchBar.searchBarStyle = .minimal
//        searchBar.autocapitalizationType = .none
//        return searchBar
//    }
//    
//    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
//        uiView.text = text
//    }
//}
//
//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
//
//
//// OLD search bar
////            HStack {
////                TextField("Search Movies, TVs...", text: $searchText)
////                    .padding([.top, .bottom, .trailing], 5)
////                    .padding(.leading, 30)
////                    .frame(height: 40.0)
////                    .foregroundColor(Color(.systemGray2))
////
////            }
////            .background(Color(.systemGray5))
////            .cornerRadius(10)
////            .padding(.horizontal, 8.0)
////            .overlay(
////                HStack {
////                    Image(systemName: "magnifyingglass")
////                        .foregroundColor(.gray)
////                    Spacer()
////                }
////                .padding(.horizontal)
////            )
