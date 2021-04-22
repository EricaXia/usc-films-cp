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
//    @State var watchlist2: [Movie] = []
    private var threeColumnGrid = [
        GridItem(.fixed(110), spacing: 4),
        GridItem(.fixed(110), spacing: 4),
        GridItem(.fixed(110), spacing: 4)
    ]
        
    var body: some View {
        ScrollView {
            // For testing only
            Button ("[TESTING] Delete watchlist") {
                UserDefaults.standard.removeObject(forKey: "watchlist")
            }
            
            
            if isWLEmpty {
                Text("Watchlist is empty")
                    .font(.title2)
                    .foregroundColor(Color.gray)
                    .padding(.top, 350.0)
            }
            
            else {
                HStack(alignment: .top) {
                    Text("Watchlist")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    Spacer()
                    
                }
                HStack {
                    LazyVGrid(columns: threeColumnGrid, alignment: .center, spacing: 4) {
                        ForEach(watchlist.removingDuplicates()) {
                            wl_movie in
                            NavigationLink(destination: DetailsView(movie: wl_movie)) {
                                
                                VStack {
                                    KFImage(URL(string: wl_movie.PosterPath)!)
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
                            }
                            
                        }
                    }
                } // end Hstack
            }
        }
        .onAppear {
            print("Load watchlist view")
            // If there are items saved to WL
            if !watchlist.isEmpty {
                isWLEmpty = false
            }
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}
