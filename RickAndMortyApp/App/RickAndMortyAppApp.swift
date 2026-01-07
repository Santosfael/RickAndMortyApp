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
            let characterService = CharacterService()
            let viewModel = HomeCharacterListViewModel(characterService: characterService)
            HomeCharacterListView(viewModel: viewModel)
        }
    }
}
