//
//  WatchlistView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI
import Kingfisher

// Dont show duplicates in watchlsit
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

struct WatchlistView: View {
    @AppStorage("watchlist") var watchlist: [Movie] = []
    @State var isWLEmpty = true
    private var threeColumnGrid = [
        GridItem(.fixed(110), spacing: 4),
        GridItem(.fixed(110), spacing: 4),
        GridItem(.fixed(110), spacing: 4)
    ]
        
    var body: some View {
        NavigationView {
        ScrollView {
            
            // For testing only
//            Button ("[TESTING] Delete watchlist") {
//                UserDefaults.standard.removeObject(forKey: "watchlist")
//            }
            
            if isWLEmpty {
                VStack {
                    Spacer()
                    Spacer()
                    Text("Watchlist is empty")
                        .font(.title)
                        .foregroundColor(Color.gray)
                        .padding(.top, 250.0)
                    Spacer()
                } // Vstack
            } // end if isWLEmpty
            
            else {
//                HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Watchlist")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    Spacer()
                    
//                } // HStack
//                HStack {
                    
                    LazyVGrid(columns: threeColumnGrid, alignment: .center, spacing: 4) {
                        ForEach(watchlist.removingDuplicates()) {
                            wl_movie in
                            NavigationLink(destination: DetailsView(movie: wl_movie)) {
                                
                                VStack {
//                                    KFImage(URL(string: wl_movie.PosterPath)!)
                                    KFImage(URL(string: wl_movie.PosterPath))
                                        .resizable()
                                        .frame(width: 110, height: 165)
                                        .scaledToFill()
                                        .clipped()
                                }
                            } // end NavLink
                            .contextMenu {
                                Button{
                                    print("Removing from watchList")
                                    if let idx = watchlist.firstIndex(where: { $0 == wl_movie }) {
                                        watchlist.remove(at: idx)
                                    }
                                } label: {
                                    Label("Remove from watchList", systemImage: "bookmark.fill")
                                }
                            } // contextMenu
                            
                        } // ForEach
                    } // LazyVGrid
                } // Vstack
                .padding(.top, -50)
                
            } // else (if WL is not empty)
        } // ScrollView
        .onAppear {
            print("Load watchlist view")
            // If there are items saved to WL
            if !watchlist.isEmpty {
                isWLEmpty = false
            }
        } // onAppear
        } // NavView
        
        // Removes white space above title
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
    } // body
} // WatchlistView

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}
