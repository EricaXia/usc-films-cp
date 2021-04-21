//
//  WatchlistView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI

struct WatchlistView: View {
    @AppStorage("watchlist") var watchlist: [Movie] = []
//    let watchlist = UserDefaults.standard.array(forKey: "watchlist")
    
    var body: some View {
        ScrollView {
            Text("Watchlist view")
                .font(.title)
            ForEach(watchlist) {
                movie in Text(movie.titleStr)
            }
        }
        .onAppear {
            print("Load watchlist view")
        }

        
//        ForEach(wl) {
//            mov in Text(mov)
//        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}
