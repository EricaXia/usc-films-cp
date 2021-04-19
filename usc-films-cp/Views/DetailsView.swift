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
                            VStack {
                            YTWrapper(videoID: movieDetails.videoIdStr).frame(width: 350, height: 200)
                            Text(movieDetails.titleStr)
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                // TODO: put more details here
                            Text(movieDetails.yearStr).multilineTextAlignment(.leading)
                            Text(movieDetails.overviewStr).multilineTextAlignment(.leading)
                        }
                        // CAST
                        castView
                        // REVIEWS
                        reviewsView
                        // RECOMMENDED
                        recView
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
                print(detailsDownloader.movieD) // this WORKS
                self.isDelay = true;
            }
        }
    }
    
    
    
    private var castView: some View {

        HStack {
            Text("Cast & Crew").font(.title2)
        }.padding(.vertical)

    }
    
    private var reviewsView: some View {
        HStack {
            Text("Reviews")
        }.padding(.vertical)
    }
    
    private var recView: some View {
        HStack {
            Text("Recommended Movies")
        }.padding(.vertical)
    }
    
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView()
//    }
//}
