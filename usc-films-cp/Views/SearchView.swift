//
//  SearchView.swift
//  usc-films
//
//  Created by Erica Xia on 4/12/21.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                Spacer()
                Text("Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.top, 20)
                    
                    
            
            HStack {
                TextField("Search Movies, TVs...", text: $searchQuery)
                    .padding([.top, .bottom, .trailing], 5)
                    .padding(.leading, 30)
                    .frame(height: 40.0)
                    .foregroundColor(Color(.systemGray2))
                    
            }
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal, 8.0)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
            )
            
            
            Spacer()
                
                } //vstack
            
        } //scrollview
        
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
