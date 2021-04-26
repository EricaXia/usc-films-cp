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
    
    @Environment(\.openURL) var openURL
    // Time delay to wait for load data
    @State var isDelay = false
    // Show More toggle for Overview text
    @State var showMoreText = true
    
    // For watchlist:
    @AppStorage("watchlist") var watchlist: [Movie] = []
    @State private var isToastShown = false
    @State private var isMovieOnWL = false
    @State var btnText = "Add to watchlist"
    @State var ToastMsg = ""
    
    
    @ObservedObject var detailsDownloader: DetailsDownloader
    
    var movie: Movie
    var media_type: String
    
    init(movie: Movie) {
        self.movie = movie
        self.media_type = movie.mediaTypeStr
        self.detailsDownloader = DetailsDownloader(movie: movie)
        detailsDownloader.getMovieDetails()
    }
    
    var body: some View {
        
        Group {
            if (isDelay) {
                if let movieDetails = detailsDownloader.movieD.first {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            // VIDEO TRAILER
                            if !movieDetails.videoIdStr.isEmpty {
                                YTWrapper(videoID: movieDetails.videoIdStr).frame(width: 350, height: 200)
                            }
                            
                            // TEXT DETAILS
                            Text(movieDetails.titleStr)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("\(movieDetails.yearStr) | \(movieDetails.genresStr)")
                            HStack {
                                Image(systemName: "star.fill").foregroundColor(.red)
                                Text("\(movieDetails.starRatingStr)/5.0").fontWeight(.medium)
                            } // Hstack
                            
                            Group {
                                Text(movieDetails.overviewStr)
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .frame(width: 350)
                                    .lineLimit( showMoreText ? 3: nil)
                                Button(action: { self.showMoreText.toggle()} )
                                    {Text(self.showMoreText ? "Show More" : "Show Less").font(.footnote).fontWeight(.medium).foregroundColor(Color.gray)}
                                    .padding(.leading, 250)
                            } // overview group
                            // CAST
                            if let castArr = movieDetails.cast {
                                Text("Cast & Crew").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                ScrollView(.horizontal, showsIndicators: true) {
                                    HStack(alignment: .top) {
                                        ForEach(castArr) {
                                            castMember in
                                            VStack(alignment: .center, spacing: 0) {
                                                KFImage(URL(string: castMember.imgPath))
                                                    .resizable()
                                                    .placeholder{
                                                        Image("cast_placeholder")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill) //fit
                                                            .frame(width: 100) //90
                                                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                                            .shadow(radius: 1)
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
                            } // cast
                            
                            
                            // REVIEWS
                            
                            if let reviewsArr = movieDetails.reviews {
                                if !reviewsArr.isEmpty {
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
                            }
                            // RECOMMENDED CAROUSEL
                            if let recsArr = movieDetails.recs {
                                if !recsArr.isEmpty {
                                    VStack(alignment: .leading) {
                                        if self.media_type == "movie" {
                                            Text("Recommended Movies").font(.title2).fontWeight(.bold).padding(.bottom, 0.0)
                                        } else {
                                            Text("Recommended TV Shows").font(.title2).fontWeight(.bold).padding(.bottom, 0.0)
                                        }
                                        ScrollView(.horizontal, showsIndicators: true) {
                                            HStack(alignment: .top, spacing: 22) {
                                                ForEach(recsArr) {
                                                    rec in
                                                    // NAVIGATION LINK HERE
                                                    NavigationLink(destination: DetailsView(movie: rec)) {
                                                        VStack {
                                                            KFImage(URL(string: rec.PosterPath))
                                                                .resizable()
                                                                .placeholder{
                                                                    Image("movie_placeholder")
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                }
                                                                .frame(width: 100, height: 150)
                                                                .cornerRadius(10)
                                                        }
                                                    } //end NavLink
                                                }
                                            }
                                        }
                                    }
                                }
                            } // Recs carousel end
                            
//                            // TOAST START
//                            Spacer()
//                                .toast(isPresented: self.$isToastShown) {
//                                    HStack {
//                                        Text("\(self.ToastMsg) \(self.isMovieOnWL ? "was added to Watchlist" : "was removed from Watchlist")")
//                                            .multilineTextAlignment(.center)
//                                            .fixedSize(horizontal: false, vertical: true)
//                                            .padding()
//                                    }
//                                }
//                            Spacer()
//                            // TOAST END

                            
                        } // VStack end
                        
                    } // Scrollview end
                    .padding()
                    
                    
                    
                } // End if let movie first
                else {
                    ProgressView()
                    Text("Fetching Data...")
                }
            } // End if
            else {
                ProgressView()
                Text("Fetching Data...")
            }
            // ends the Group
        }.onAppear {
//            detailsDownloader.getMovieDetails()
//            print("Details downloaded in view")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                //                print(detailsDownloader.movieD) // this WORKS
                self.isDelay = true;
            }
        } // end onAppear
            
        
        // Nav Bar items
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {Text("")}
            ToolbarItemGroup {
                HStack {
                    
                    // WL btn start
                    Button{
                        self.ToastMsg = movie.titleStr
                        // if movie already found on WL:
                        if let idx = watchlist.firstIndex(where: { $0 == movie }) {
                            // Click btn to REMOVE from WL
                            watchlist.remove(at: idx)
                            self.isMovieOnWL = false
                            // show Toast
                            withAnimation {
                                self.isToastShown = true
                            }
                        } else {
                            // if the movie is NOT on the WL yet
                            // show Toast
                            withAnimation {
                                self.isToastShown = true
                            }
                            // Add to WL
                            watchlist.append(movie)
                            print("Added movie \(movie.titleStr) to WL")
                            self.isMovieOnWL = true
                        } //end if
                    } label: {
                        HStack {
                            Image(systemName: "\(watchlist.firstIndex(where: { $0 == movie }) != nil ? "bookmark.fill" : "bookmark")")
                        }
                    } // WL btn end
                    
                    
                    Button {
                        print("Share on Facebook")
                        openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/\(movie.idStr)")!)
                    } label: {
                        Image("facebook")
                            .resizable()
                            .frame(width: 16.0, height: 16.0)
                    }
                    Button {
                        print("Share on Twitter")
                        openURL(URL(string: "https://www.twitter.com/intent/tweet?text=Check%20out%20this%20link:%20https://www.themoviedb.org/movie/\(movie.idStr)&hashtags=CSCI571USCFilms")!)
                        
                    } label: {
                        Image("twitter")
                            .resizable()
                            .frame(width: 16.0, height: 16.0)
                    }
                } // ends HStack
            } // end toolbaritemgroup
        } // ends toolbar
        
        
    } // ends the body
}
