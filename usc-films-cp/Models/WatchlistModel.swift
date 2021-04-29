import SwiftUI

class WatchlistModel: ObservableObject{

    @AppStorage("watchlist") var watchlist: [Movie] = [Movie]()
    // Currently Dragging Movie Tile...
    @Published var currentMovie: Movie?
    
}
