//
//  MainTabView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI

struct MainTabView: View {
    
    enum Tabs: Int {
        case search
        case home
        case watchlist
    }
    
    @State private var currentTab = Tabs.home
    
    var body: some View {
        TabView(selection: $currentTab) {

            SearchView().tabItem {
                myTabItem(text: "Search", image: "magnifyingglass")
            }.tag(Tabs.search)
            
            HomeView().tabItem {
                myTabItem(text: "Home", image: "house")
            }.tag(Tabs.home)
            
            WatchlistView().tabItem {
                myTabItem(text: "Watchlist", image: "suit.heart")
            }.tag(Tabs.watchlist)
        }
    }
    
    private func myTabItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image).imageScale(.small)
            Text(text)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
