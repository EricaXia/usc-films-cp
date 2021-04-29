import SwiftUI

struct DropViewDelegate: DropDelegate {
    
    var movie: Movie
    var watchlistModel: WatchlistModel
    
    func performDrop(info: DropInfo) -> Bool {
        watchlistModel.currentMovie = nil
        return true
    }
    
    // When User Dragged Into New Page...
    func dropEntered(info: DropInfo) {
        
        // UnComment This Just a try...
        if watchlistModel.currentMovie == nil{
            watchlistModel.currentMovie = movie
        }
        
        // Getting From And To Index...
        
        // From Index
        let fromIndex = watchlistModel.watchlist.firstIndex { (movie) -> Bool in
            return movie.idStr == watchlistModel.currentMovie?.idStr
        } ?? 0
        
        // To Index...
        let toIndex = watchlistModel.watchlist.firstIndex { (movie) -> Bool in
            return movie.idStr == self.movie.idStr
        } ?? 0
        
        // Safe Check if both are not same...
        if fromIndex != toIndex{
            // Animation...
            withAnimation(.default){
                
                // Swapping Data...
                let fromMovie = watchlistModel.watchlist[fromIndex]
                watchlistModel.watchlist[fromIndex] = watchlistModel.watchlist[toIndex]
                watchlistModel.watchlist[toIndex] = fromMovie
            }
        }
    }
    
    // setting Action as Move...
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
