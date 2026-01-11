//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Rafael on 03/01/26.
//

import Foundation

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: LocationPerson
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Origin: Codable {
    let name: String
    let url: String
}

struct LocationPerson: Codable {
    let name: String
    let url: String
}
