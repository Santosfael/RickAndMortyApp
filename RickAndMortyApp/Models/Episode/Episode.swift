//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

import Foundation

struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String

    // Fazer o mapeamento do airDate e air_date, já que a api retorna snake_case
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
        case url
        case created
    }
}
