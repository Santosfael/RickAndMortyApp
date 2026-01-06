//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by Rafael on 03/01/26.
//

import SwiftUI

@main
struct RickAndMortyAppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeCharacterListView(viewModel: CharacterListViewModel(characterService: CharacterService()))
        }
    }
}
