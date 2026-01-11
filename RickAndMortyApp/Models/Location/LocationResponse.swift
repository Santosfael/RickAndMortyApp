//
//  LocationResponse.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

import Foundation

struct LocationResponse: Codable {
    let info: Info
    let results: [Location]
}
