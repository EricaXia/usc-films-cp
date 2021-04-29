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
//    @AppStorage("watchlist") var watchlist: [Movie] = [Movie]()
    @StateObject var watchlistModel = WatchlistModel()
    
    @State private var isToastShown_TR = false
    @State private var isToastShown_Pop = false
    @State private var isMovieOnWL = false
    @State var btnText = "Add to watchlist"
    @State var ToastMsg_TR = ""
    @State var ToastMsg_Pop = ""
    
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
        
        if (downloader.movies.count == 5) {
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
                                    
                                } // Vstack end
                                .padding(.vertical)}
                            
                            
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
                            
                            
                            LazyVStack(alignment:.center) {
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
            } // end NavView
        } // end if
        
        else {
            VStack {
                ProgressView()
                Text("Fetching Data...")
            }
        }
        // end body
    } // body
    
    // Top Rated Movies View
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
                            
                        } // Navlink
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu {
                            // WL btn start
                            Button{
                                self.ToastMsg_TR = movie.titleStr
                                // if movie already found on WL:
                                if let idx = watchlistModel.watchlist.firstIndex(where: { $0 == movie }) {
                                    // Click btn to REMOVE from WL
                                    watchlistModel.watchlist.remove(at: idx)
                                    self.isMovieOnWL = false
                                    // show Toast
                                    withAnimation {
                                        self.isToastShown_TR = true
                                    }
                                } else {
                                    // if the movie is NOT on the WL yet
                                    // show Toast
                                    withAnimation {
                                        self.isToastShown_TR = true
                                    }
                                    // Add to WL
                                    watchlistModel.watchlist.append(movie)
                                    print("Added movie \(movie.titleStr) to WL")
                                    self.isMovieOnWL = true
                                } //end if
                            } label: {
                                HStack {
                                    Text("\(watchlistModel.watchlist.firstIndex(where: { $0 == movie }) != nil ? "Remove from watchList" : "Add to watchList")")
                                    Image(systemName: "\(watchlistModel.watchlist.firstIndex(where: { $0 == movie }) != nil ? "bookmark.fill" : "bookmark")")
                                }
                            } // WL btn end
                            
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
                .toast(isPresented: self.$isToastShown_TR) {
                    HStack {
                        Text("\(self.ToastMsg_TR) \(self.isMovieOnWL ? "was added to Watchlist" : "was removed from Watchlist")")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
                }
            Spacer()
            // TOAST END
            
        } //VStack
        .padding(.bottom, 50)
    }
    
    // Top Rated TV Shows View
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
                            // WL btn start
                            Button{
                                self.ToastMsg_TR = movie.titleStr
                                // if movie already found on WL:
                                if let idx = watchlistModel.watchlist.firstIndex(where: { $0 == movie }) {
                                    // Click btn to REMOVE from WL
                                    watchlistModel.watchlist.remove(at: idx)
                                    self.isMovieOnWL = false
                                    // show Toast
                                    withAnimation {
                                        self.isToastShown_TR = true
                                    }
                                } else {
                                    // if the movie is NOT on the WL yet
                                    // show Toast
                                    withAnimation {
                                        self.isToastShown_TR = true
                                    }
                                    // Add to WL
                                    watchlistModel.watchlist.append(movie)
                                    print("Added movie \(movie.titleStr) to WL")
                                    self.isMovieOnWL = true
                                } //end if
                            } label: {
                                HStack {
                                    Text("\(watchlistModel.watchlist.firstIndex(where: { $0 == movie }) != nil ? "Remove from watchList" : "Add to watchList")")
                                    Image(systemName: "\(watchlistModel.watchlist.firstIndex(where: { $0 == movie }) != nil ? "bookmark.fill" : "bookmark")")
                                }
                            } // WL btn end
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
                .toast(isPresented: self.$isToastShown_TR) {
                    HStack {
                        Text("\(self.ToastMsg_TR) \(self.isMovieOnWL ? "was added to Watchlist" : "was removed from Watchlist")")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
                }
            Spacer()
            // TOAST END
            
        } //Vstack
        .padding(.bottom, 50)
    }
    
    // Popular Movies View
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
                            // WL btn start
                            Button{
                                self.ToastMsg_Pop = movie.titleStr
                                // if movie already found on WL:
                                if let idx = watchlistModel.watchlist.firstIndex(where: { $0 == movie }) {
                                    // Click btn to REMOVE from WL
                                    watchlistModel.watchlist.remove(at: idx)
                                    self.isMovieOnWL = false
                                    // show Toast
                                    withAnimation {
                                        self.isToastShown_Pop = true
                                    }
                                } else {
                                    // if the movie is NOT on the WL yet
                                    // show Toast
                                    withAnimation {
                                        self.isToastShown_Pop = true
                                    }
                                    // Add to WL
                                    watchlistModel.watchlist.append(movie)
                                    print("Added movie \(movie.titleStr) to WL")
                                    self.isMovieOnWL = true
                                } //end if
                            } label: {
                                HStack {
                                    Text("\(watchlistModel.watchlist.firstIndex(where: { $0 == movie }) != nil ? "Remove from watchList" : "Add to watchList")")
                                    Image(systemName: "\(watchlistModel.watchlist.firstIndex(where: { $0 == movie }) != nil ? "bookmark.fill" : "bookmark")")
                                }
                            } // WL btn end
                            
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
                .toast(isPresented: self.$isToastShown_Pop) {
                    HStack {
                        Text("\(self.ToastMsg_Pop) \(self.isMovieOnWL ? "was added to Watchlist" : "was removed from Watchlist")")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
                }
            Spacer()
            // TOAST END
            
            
        } // Vstack
        .padding(.bottom, 50)
    }
    
    // Popular TV Shows View
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
                            // WL btn start
                            Button{
                                self.ToastMsg_Pop = movie.titleStr
                                // if movie already found on WL:
                                if let idx = watchlistModel.watchlist.firstIndex(where: { $0 == movie }) {
                                    // Click btn to REMOVE from WL
                                    watchlistModel.watchlist.remove(at: idx)
                                    self.isMovieOnWL = false
                                    // show Toast
                                    withAnimation {
                                        self.isToastShown_Pop = true
                                    }
                                } else {
                                    // if the movie is NOT on the WL yet
                                    // show Toast
                                    withAnimation {
                                        self.isToastShown_Pop = true
                                    }
                                    // Add to WL
                                    watchlistModel.watchlist.append(movie)
                                    print("Added movie \(movie.titleStr) to WL")
                                    self.isMovieOnWL = true
                                } //end if
                            } label: {
                                HStack {
                                    Text("\(watchlistModel.watchlist.firstIndex(where: { $0 == movie }) != nil ? "Remove from watchList" : "Add to watchList")")
                                    Image(systemName: "\(watchlistModel.watchlist.firstIndex(where: { $0 == movie }) != nil ? "bookmark.fill" : "bookmark")")
                                }
                            } // WL btn end
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
                .toast(isPresented: self.$isToastShown_Pop) {
                    HStack {
                        Text("\(self.ToastMsg_Pop) \(self.isMovieOnWL ? "was added to Watchlist" : "was removed from Watchlist")")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
                }
            Spacer()
            // TOAST END
            
        } //Vstack
        .padding(.bottom, 50)
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
} // HomeView

struct BoolSelect: Identifiable {
    var id = UUID()
    var isMovieOnWL: Bool
}
