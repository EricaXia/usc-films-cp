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
    private var threeColumnGrid = [GridItem(.flexible(), spacing: 2),
                                   GridItem(.flexible(), spacing: 2),
                                   GridItem(.flexible(), spacing: 2)]
    
    var body: some View {
        ScrollView {
            // For testing only
            Button ("Delete watchlist") {
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
                HStack(spacing: 0) {
                    LazyVGrid(columns: threeColumnGrid, alignment: .center, spacing: 2) {
                        ForEach(watchlist.removingDuplicates()) {
                            wl_movie in
                            NavigationLink(destination: DetailsView(movie: wl_movie)){
                                KFImage(URL(string: wl_movie.PosterPath)!)
                                    .resizable()
                                    .frame(width: 100, height: 150)
                                    .scaledToFill()
                                    .clipped()
                                    .padding(.horizontal, -10)
                            } // end NavLink
                            
                            .contextMenu {
                                Button{
                                    print("Remove from watchList")
                                    // TODO drop from watchlist array at specific movie
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
