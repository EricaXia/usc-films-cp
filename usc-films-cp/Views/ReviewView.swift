//
//  ReviewView.swift
//  usc-films-cp
//
//  Created by Erica Xia on 4/19/21.
//

import SwiftUI

struct ReviewView: View {
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
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
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
    } // body
} // view
