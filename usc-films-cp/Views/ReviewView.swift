//
//  ReviewView.swift
//  usc-films-cp
//
//  Created by Erica Xia on 4/19/21.
//

import SwiftUI

struct ReviewView: View {
//    @ObservedObject var detailsDownloader: DetailsDownloader
//    @State var isDelay = false
    var movie: Movie
    var review_num: Int
    var reviewsArr: Array<MovieD.ReviewItem>
    
    init(movie: Movie, review_num: Int, reviewsArr: Array<MovieD.ReviewItem>) {
        self.movie = movie
        self.review_num = review_num
        self.reviewsArr = reviewsArr
    }
    
    var body: some View {
        ScrollView {
        ForEach(0..<reviewsArr.count) {
            i in
            if (i == review_num) {
                VStack(alignment: .leading) {
                        Text(movie.titleStr).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(.bold)
                        Text("By \(reviewsArr[i].authorStr) on \(reviewsArr[i].reviewDateStr)").foregroundColor(.gray)
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.red)
                            Text("\(reviewsArr[i].starRatingReviewStr)/5.0").fontWeight(.medium)
                        }
                        Divider()
                        Text(reviewsArr[i].contentStr)
                        Spacer()
                } // VStack
                .padding()
            } // if
        } // ForEach
        } // ScrollView
    }
//    var body: some View {
//        Group {
//            if (isDelay) {
//                if let movieDetails = detailsDownloader.movieD.first {
//                    if let reviewsArr = movieDetails.reviews {
//                        ScrollView(.vertical) {
//
//                            VStack(alignment: .leading, spacing: 10) {
//                                Spacer()
//                                Spacer()
//                                Spacer()
//                                Text(movieDetails.titleStr).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(.bold)
//                                Text("By \(reviewsArr[review_num].authorStr) on \(reviewsArr[review_num].reviewDateStr)").foregroundColor(.gray)
//                                HStack {
//                                    Image(systemName: "star.fill").foregroundColor(.red)
//                                    Text("\(reviewsArr[review_num].starRatingReviewStr)/5.0").fontWeight(.medium)
//                                }
//                                Divider()
//                                Text(reviewsArr[review_num].contentStr)
//                                Spacer()
//                            }
//                        }.padding()
//                    }
//                }
//            }
//        }.onAppear {
//            detailsDownloader.getMovieDetails()
//            print("Review View Loaded")
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
//                self.isDelay = true;
//            }
//        }
//    }
}

//struct ReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewView()
//    }
//}
