//
//  MainTabView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 11/01/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeCharacterListView(viewModel: HomeCharacterListViewModel(apiService: APIService()))
                .tabItem {
                    Label("Character", systemImage: "person.3.fill")
                }
                .tag(0)
            
            LocationListView(viewModel: LocationListViewModel(apiService: APIService()))
                .tabItem {
                    Label("Locations", systemImage: "globe")
                }
                .tag(1)
            
            EpisodeListView(viewModel: EpisodeListViewModel(apiService: APIService()))
                .tabItem {
                    Label("Episodes", systemImage: "tv.fill")
                }
                .tag(2)
         }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
