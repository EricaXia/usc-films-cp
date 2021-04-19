//
//  DetailsView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI
import Kingfisher
import youtube_ios_player_helper

struct YTWrapper : UIViewRepresentable {
    var videoID : String
    let playerVars = ["controls": 1, "playsinline": 1]
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.load(withVideoId: videoID, playerVars: playerVars)
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        //
    }
}

struct DetailsView: View {
    // Time delay to wait for load data
    @State var isDelay = false
    // Show More toggle for Overview text
    @State var showMoreText = true
    
    @ObservedObject var detailsDownloader: DetailsDownloader
    
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        self.detailsDownloader = DetailsDownloader(movie: movie)
    }
    
    var body: some View {
        Group {
            if (isDelay) {
                if let movieDetails = detailsDownloader.movieD.first {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            // VIDEO TRAILER
                            YTWrapper(videoID: movieDetails.videoIdStr).frame(width: 350, height: 200)
                            // TEXT DETAILS
                            Text(movieDetails.titleStr)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("\(movieDetails.yearStr) | \(movieDetails.genresStr)")
                            HStack {
                                Image(systemName: "star.fill").foregroundColor(.red)
                                Text("\(movieDetails.starRatingStr)/5.0").fontWeight(.medium)
                            }
                            
                            Group {
                                Text(movieDetails.overviewStr)
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .frame(width: 350)
                                    .lineLimit( showMoreText ? 3: nil)
                                Button(action: { self.showMoreText.toggle()} ) { Text("Show More...").font(.footnote).fontWeight(.medium).foregroundColor(Color.gray) }.padding(.leading, 250)
                            }
                            // CAST
                            if let castArr = movieDetails.cast {
                                Text("Cast & Crew").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack(alignment: .top) {
                                        ForEach(castArr) {
                                            castMember in
                                            VStack(alignment: .center, spacing: 0) {
                                                KFImage(URL(string: castMember.imgPath)!)
                                                    .resizable()
                                                    .placeholder{
                                                        Image("cast_placeholder").scaledToFit()
                                                    }
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 90)
                                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                                    .shadow(radius: 1)
                                                Text(castMember.nameStr)
                                                    .font(.caption)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(width: 132)
                                                    .fixedSize(horizontal: true, vertical: false)
                                            }.padding(.trailing, -20)
                                        }
                                    }
                                }
                                .padding(.bottom, 10.0)
                            }
                            
                            
                            // REVIEWS
                            
                            if let reviewsArr = movieDetails.reviews {
                                Text("Reviews").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                
                                ForEach(0..<reviewsArr.count) {
                                    i in
                                    NavigationLink(destination: ReviewView(movie: movie, review_num: i)){
                                        
                                        VStack(alignment: .leading, spacing: 10) {
                                            
                                            Text("A review by \(reviewsArr[i].authorStr)").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                            Text("Written by \(reviewsArr[i].authorStr) on \(reviewsArr[i].reviewDateStr)").foregroundColor(.gray).padding(EdgeInsets(top: -10, leading: 10, bottom: 2, trailing: 10))
                                            HStack {
                                                Image(systemName: "star.fill").foregroundColor(.red).padding(.leading, 10.0)
                                                Text("\(reviewsArr[i].starRatingReviewStr)/5.0").fontWeight(.medium)
                                            }
                                            
                                            Text(reviewsArr[i].contentStr)
                                                .fontWeight(.medium)
                                                .frame(width: 350)
                                                .lineLimit(4)
                                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 2))
                                            
                                            
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.gray), lineWidth: 1)
                                    )
                                    
                                    
                                    
                                }
                            }
                            // RECOMMENDED CAROUSEL
                            if let recsArr = movieDetails.recs {
                                VStack(alignment: .leading) {
                                Text("Recommended Movies").font(.title2).fontWeight(.bold).padding(.bottom, 0.0)
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack(alignment: .top, spacing: 22) {
                                            ForEach(recsArr) {
                                                rec in
                                                VStack {
                                                    KFImage(URL(string: rec.PosterPath)!)
                                                        .resizable()
                                                        .placeholder{
                                                            Image("movie_placeholder").scaledToFit()
                                                        }
                                                        .frame(width: 100, height: 150)
                                                        .cornerRadius(10)
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                
                                
                            }
                            
                            
                        }
                        // ends the ScrollView
                    }.padding()
                } else {
                    Text("Loading...")
                }
            } else {
                Text("Loading...")
            }
            
        }.onAppear {
            detailsDownloader.getMovieDetails()
            print("Details downloaded in view")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                //                print(detailsDownloader.movieD) // this WORKS
                self.isDelay = true;
            }
        }
    }
}



//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView()
//    }
//}
