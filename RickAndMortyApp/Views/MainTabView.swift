//
//  MainTabView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 11/01/26.
//

import SwiftUI

struct MainTabView: View {
    
    private let factory: ViewModelFactory

    init(factory: ViewModelFactory = DefaultVieModelFactory()) {
        self.factory = factory
    }
    var body: some View {
        TabView {
            HomeCharacterListView(viewModel: factory.makeCharacterListViewModel())
                .tabItem {
                    Label("Character", systemImage: "person.3.fill")
                }
                .tag(0)
            
            LocationListView(viewModel: factory.makeLocationListViewModel())
                .tabItem {
                    Label("Locations", systemImage: "globe")
                }
                .tag(1)
            
            EpisodeListView(viewModel: factory.makeEpisodeListViewModel())
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
