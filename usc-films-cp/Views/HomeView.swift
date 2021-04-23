//
//  HomeView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI
import Kingfisher

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct HomeView: View {
    
    @Environment(\.openURL) var openURL
    
    @State private var showTVShows = false
    @State var isDelay = false
    
    // For watchlist:
    @AppStorage("watchlist") var watchlist: [Movie] = []
    @State private var isToastShown = false
    @State private var isMovieOnWL = false
    @State var btnText = "Add to watchlist"
    
    // For downloading data
    @ObservedObject var downloader = Downloader()
    
    init() {
        print("Download movies")
        downloader.getNowPlaying()
        downloader.getTopRatedMovies()
        downloader.getPopularMovies()
        
        print("Download TV shows")
        downloader.getAiringToday()
        downloader.getTopRatedTv()
        downloader.getPopularTv()
    }
    
    var body: some View {
        NavigationView {
            if showTVShows {
                // TV SHOWS content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("USC Films")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        HStack {
                            Text("Airing Today")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        
                        VStack(alignment:.center) {
                            HStack {
                                GeometryReader { proxy in
                                    MainSlideView(numSlides: 5) {
                                        ForEach(downloader.tvshows) { movie in
                                            NavigationLink(destination: DetailsView(movie: movie)){
                                                ZStack {
                                                    KFImage(URL(string: movie.PosterPath)!)
                                                        .blur(radius: 25)
                                                        .resizable()
                                                        .frame(width: proxy.size.width * 0.98, height: proxy.size.height)
                                                        .scaledToFill()
                                                        .clipped()
                                                        .opacity(0.8)
                                                    
                                                    KFImage(URL(string: movie.PosterPath)!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                                                        .clipped()
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(height: 280, alignment: .center)
                                
                            }.padding(.vertical)}
                        
                        
                        Spacer()
                        
                        //Carousels
                        
                        VStack(alignment: .leading) {
                            topRatedTv
                            Spacer()
                            popularTv
                        }
                        
                        VStack(alignment: .center) {
                            
                            Link(destination: URL(string: "https://www.themoviedb.org/")!, label: {
                                Text("Powered by TMDB \nDeveloped by Erica Xia")                     .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.center)
                            })
                        }
                    }
                    
                    
                    Spacer()
                }.padding()
                
                // Nav Bar items
                .navigationBarTitle("USC Films", displayMode: .inline)
                .toolbar {
                    Button("Movies") {
                        showTVShows.toggle()
                    }}
            } else {
                
                // MOVIES CONTENT
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("USC Films")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        HStack {
                            Text("Now Playing")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        
                        VStack(alignment:.center) {
                            HStack {
                                GeometryReader { proxy in
                                    MainSlideView(numSlides: 5) {
                                        ForEach(downloader.movies) { movie in
                                            NavigationLink(destination: DetailsView(movie: movie)){
                                                ZStack {
                                                    KFImage(URL(string: movie.PosterPath)!)
                                                        .blur(radius: 25)
                                                        .resizable()
                                                        .frame(width: proxy.size.width * 0.98, height: proxy.size.height)
                                                        .scaledToFill()
                                                        .clipped()
                                                        .opacity(0.8)
                                                    
                                                    KFImage(URL(string: movie.PosterPath)!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                                                        .clipped()
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(height: 280, alignment: .center)
                                
                            }.padding(.vertical)}
                        
                        
                        Spacer()
                        
                        //Carousels
                        
                        VStack(alignment: .leading) {
                            topRatedMovies
                            Spacer()
                            popularMovies

                        }
                        
                        VStack(alignment: .center) {
                            
                            Link(destination: URL(string: "https://www.themoviedb.org/")!, label: {
                                Text("Powered by TMDB \nDeveloped by Erica Xia")                     .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.center)
                            })
                        }
                        
                        
                    }
                    
                    
                    Spacer()
                        // Adds padding and Nav Bar
                        
                        // TODO: only show the USC Films title when scrolling down?
                        
                        .navigationBarTitle("USC Films", displayMode: .inline)
                        .toolbar {
                            Button("TV Shows") {
                                showTVShows.toggle()
                            }}
                }
                .padding()
            }
            
            
        }
        // end body
    }
    
    private var topRatedMovies: some View {
        VStack(alignment: .leading) {
            Text("Top Rated").font(.title).fontWeight(.bold).padding(.bottom, 0.0)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: 22) {
                    ForEach(downloader.movies_toprated) {
                        movie in
                        NavigationLink(destination: DetailsView(movie: movie)){
                            VStack {
                                KFImage(URL(string: movie.PosterPath)!)
                                    .resizable()
                                    .placeholder{
                                        Image("movie_placeholder")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(10)
                                Text(movie.titleStr)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 105.0)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(movie.yearStr)
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.center)
                                
                            } // VStack
                            
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            Button{
                                // TODO Add to watchlist btn and toast msg here
                                
                                // if the movie is NOT on the watchlist yet
                                if 	(!self.isMovieOnWL) {
                                    print("Add to watchList")
                                    
                                    withAnimation {
                                        self.isToastShown = true
                                    }

                                    watchlist.append(movie)
                                } // end if
                                
                                
                            } label: {
                                Label(self.btnText, systemImage: "bookmark")
                            }
                            
                            Button {
                                print("Share on Facebook")
                                openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/\(movie.idStr)")!)
                            } label: {
                                Label("Share on Facebook", image: "facebook")
                            }
                            Button {
                                print("Share on Twitter")
                                openURL(URL(string: "https://www.twitter.com/intent/tweet?text=Check%20out%20this%20link:%20https://www.themoviedb.org/movie/\(movie.idStr)&hashtags=CSCI571USCFilms")!)
                                
                            } label: {
                                Label("Share on Twitter", image: "twitter")
                            }
                        }
                    } // ForEach
                    
                } // HStack
                
                
            } // Scrollview
            
            // TOAST START
            Spacer()
            .toast(isPresented: self.$isToastShown) {
                HStack {
                    //                            Text("\(movie.titleStr) \(self.isMovieOnWL ? "was added" : "was removed")")
                    Text("TESTTESTTESTTEST").foregroundColor(.white)
                }
            }
            Spacer()
            // TOAST END
            
        } //VStack
        .padding(.bottom, 50)
    } // End View
    
    private var topRatedTv: some View {
        VStack(alignment: .leading) {
            Text("Top Rated").font(.title).fontWeight(.bold).padding(.bottom, 0.0)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: 22) {
                    ForEach(downloader.tvshows_toprated) {
                        movie in
                        NavigationLink(destination: DetailsView(movie: movie)){
                            VStack {
                                KFImage(URL(string: movie.PosterPath)!)
                                    .resizable()
                                    .placeholder{
                                        Image("movie_placeholder")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(10)
                                Text(movie.titleStr)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 105.0)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(movie.yearStr)
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            Button{
                                print("Add to watchList")
                                watchlist.append(movie)
                            } label: {
                                Label("Add to watchList", systemImage: "bookmark")
                            }
                            Button {
                                print("Share on Facebook")
                                openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/\(movie.idStr)")!)
                            } label: {
                                Label("Share on Facebook", image: "facebook")
                            }
                            Button {
                                print("Share on Twitter")
                                openURL(URL(string: "https://www.twitter.com/intent/tweet?text=Check%20out%20this%20link:%20https://www.themoviedb.org/movie/\(movie.idStr)&hashtags=CSCI571USCFilms")!)
                                
                            } label: {
                                Label("Share on Twitter", image: "twitter")
                            }
                        }
                    }
                }
            }
        }
        .padding(.bottom, 50)
    }
    
    private var popularMovies: some View {
        VStack(alignment: .leading) {
            Text("Popular").font(.title).fontWeight(.bold).padding(.bottom, 0.0)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: 22) {
                    ForEach(downloader.movies_popular) {
                        movie in
                        NavigationLink(destination: DetailsView(movie: movie)){
                            VStack {
                                KFImage(URL(string: movie.PosterPath)!)
                                    .resizable()
                                    .placeholder{
                                        Image("movie_placeholder")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(10)
                                Text(movie.titleStr)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 105.0)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(movie.yearStr)
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            Button{
                                // TODO Add to watchlist btn and toast msg here
                                
                                // if the movie is NOT on the watchlist yet
                                if     (!self.isMovieOnWL) {
                                    print("Add to watchList")
                                    
                                    withAnimation {
                                        self.isToastShown = true
                                    }

                                    watchlist.append(movie)
                                } // end if
                                
                                
                            } label: {
                                Label(self.btnText, systemImage: "bookmark")
                            }
                            Button {
                                print("Share on Facebook")
                                openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/\(movie.idStr)")!)
                            } label: {
                                Label("Share on Facebook", image: "facebook")
                            }
                            Button {
                                print("Share on Twitter")
                                openURL(URL(string: "https://www.twitter.com/intent/tweet?text=Check%20out%20this%20link:%20https://www.themoviedb.org/movie/\(movie.idStr)&hashtags=CSCI571USCFilms")!)
                                
                            } label: {
                                Label("Share on Twitter", image: "twitter")
                            }
                        }
                    }
                }
            }
            
            // TOAST START
            Spacer()
            .toast(isPresented: self.$isToastShown) {
                HStack {
                    //                            Text("\(movie.titleStr) \(self.isMovieOnWL ? "was added" : "was removed")")
                    Text("TESTTESTTESTTEST").foregroundColor(.white)
                }
            }
            Spacer()
            // TOAST END
            
        } // Vstack
        .padding(.bottom, 50)
    }
    
    private var popularTv: some View {
        VStack(alignment: .leading) {
            Text("Popular").font(.title).fontWeight(.bold).padding(.bottom, 0.0)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: 22) {
                    ForEach(downloader.tvshows_popular) {
                        movie in
                        NavigationLink(destination: DetailsView(movie: movie)){
                            VStack {
                                KFImage(URL(string: movie.PosterPath)!)
                                    .resizable()
                                    .placeholder{
                                        Image("movie_placeholder")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(10)
                                Text(movie.titleStr)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 105.0)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(movie.yearStr)
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            Button{
                                print("Add to watchList")
                                watchlist.append(movie)
                            } label: {
                                Label("Add to watchList", systemImage: "bookmark")
                            }
                            Button {
                                print("Share on Facebook")
                                openURL(URL(string: "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/movie/\(movie.idStr)")!)
                            } label: {
                                Label("Share on Facebook", image: "facebook")
                            }
                            Button {
                                print("Share on Twitter")
                                openURL(URL(string: "https://www.twitter.com/intent/tweet?text=Check%20out%20this%20link:%20https://www.themoviedb.org/movie/\(movie.idStr)&hashtags=CSCI571USCFilms")!)
                                
                            } label: {
                                Label("Share on Twitter", image: "twitter")
                            }
                        }
                    }
                }
            }
        }
        .padding(.bottom, 50)
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
}
