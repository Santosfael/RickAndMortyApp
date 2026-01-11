//
//  Location.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

import Foundation

// Codable - Converter Json para objetos em Swift
// Identifiable - Identificador para uso em listas no SwiftUI
struct Location: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
