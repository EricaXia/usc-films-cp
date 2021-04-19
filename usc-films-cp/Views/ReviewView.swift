//
//  ReviewView.swift
//  usc-films-cp
//
//  Created by Erica Xia on 4/19/21.
//

import SwiftUI

struct ReviewView: View {
    @ObservedObject var detailsDownloader: DetailsDownloader
    @State var isDelay = false
    var movie: Movie
    var review_num: Int
    
    init(movie: Movie, review_num: Int) {
        self.movie = movie
        self.detailsDownloader = DetailsDownloader(movie: movie)
        self.review_num = review_num
    }
    
    var body: some View {
        Group {
            if (isDelay) {
                if let movieDetails = detailsDownloader.movieD.first {
                    if let reviewsArr = movieDetails.reviews {
                        ScrollView(.vertical) {
                        Text(reviewsArr[review_num].authorStr)
                        Text(reviewsArr[review_num].contentStr)
                        }
                    }
                }
            }
        }.onAppear {
            detailsDownloader.getMovieDetails()
            print("Details downloaded in review view")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                self.isDelay = true;
            }
    }
}
}

//struct ReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewView()
//    }
//}
