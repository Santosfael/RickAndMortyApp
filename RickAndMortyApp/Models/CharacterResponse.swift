//
//  CharacterResponse.swift
//  RickAndMortyApp
//
//  Created by Rafael on 03/01/26.
//

import Foundation

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let previous: String?
}
