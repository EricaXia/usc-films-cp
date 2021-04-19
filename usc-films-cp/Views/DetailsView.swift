//
//  DetailsView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI
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
    @State var isDelay = false
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
                            YTWrapper(videoID: movieDetails.videoIdStr).frame(width: 350, height: 200)
                            Text(movieDetails.titleStr)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("\(movieDetails.yearStr) | GENRES here")
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
                        castView
                        // REVIEWS
                        reviewsView
                        // RECOMMENDED
                        recView
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
    
    
    
    
    
    
    
    private var castView: some View {
        
        HStack {
            Text("Cast & Crew").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }.padding(.vertical)
        
    }
    
    private var reviewsView: some View {
        HStack {
            Text("Reviews").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }.padding(.vertical)
    }
    
    private var recView: some View {
        HStack {
            Text("Recommended Movies").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }.padding(.vertical)
    }
    
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView()
//    }
//}
