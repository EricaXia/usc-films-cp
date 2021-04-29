//
//  WatchlistView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI
import Kingfisher

struct WatchlistView: View {
//    @AppStorage("watchlist") var watchlist: [Movie] = [Movie]()
    
    @StateObject var watchlistModel = WatchlistModel()
    @State var isWLEmpty = true
    private var threeColumnGrid = [
        GridItem(.fixed(110), spacing: 4),
        GridItem(.fixed(110), spacing: 4),
        GridItem(.fixed(110), spacing: 4)
    ]
        
    var body: some View {
        NavigationView {
        ScrollView {
            
////             For testing only
//            Button ("[TESTING] Delete watchlist") {
//                UserDefaults.standard.removeObject(forKey: "watchlist")
//            }
            
            if watchlistModel.watchlist.isEmpty {
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
                VStack(alignment: .leading) {
                    Text("Watchlist")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    Spacer()
                    
                    LazyVGrid(columns: threeColumnGrid, alignment: .center, spacing: 4) {
                        ForEach(watchlistModel.watchlist) {
                            wl_movie in
                            NavigationLink(destination: DetailsView(movie: wl_movie)) {
                                
                                VStack {
                                    KFImage(URL(string: wl_movie.PosterPath))
                                        .resizable()
                                        .frame(width: 110, height: 165)
                                        .scaledToFill()
                                        .clipped()
                                    
                                        // DRAG AND DROP START
                                        .onDrag({
                                            watchlistModel.currentMovie = wl_movie
                                            return NSItemProvider(contentsOf: URL(string: "\(wl_movie.idStr)")!)!
                                        })
                                        .onDrop(of: [.url], delegate: DropViewDelegate(movie: wl_movie, watchlistModel: watchlistModel))
                                        // DRAG AND DROP END
                                    
                                }
                                
                            } // end NavLink
                            .contextMenu {
                                Button{
                                    print("Removing from watchList")
                                    if let idx = watchlistModel.watchlist.firstIndex(where: { $0 == wl_movie }) {
                                        watchlistModel.watchlist.remove(at: idx)
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
            print("Load watchlist view OnAppear")
//            // If there are items saved to WL
//            if !watchlistModel.watchlist.isEmpty {
//                isWLEmpty = false
//            }
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
