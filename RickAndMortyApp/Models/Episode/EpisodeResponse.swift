//
//  EpisodeResponse.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

import Foundation

struct EpisodeResponse: Codable {
    let info: Info
    let results: [Episode]
}
