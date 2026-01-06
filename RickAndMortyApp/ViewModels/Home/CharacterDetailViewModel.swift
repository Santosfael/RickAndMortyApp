//
//  CharacterDetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Rafael on 04/01/26.
//

import Foundation
internal import Combine

final class CharacterDetailViewModel: ObservableObject {
    @Published public private(set) var character: Character
    
    init(character: Character) {
        self.character = character
    }
}


