//
//  ConfigManager.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

import Foundation

struct ConfigManager {
    static var baseURL: String {
        let url = ProcessInfo.processInfo.environment["BASE_URL"] ?? "https://rickandmortyapi.com/api"
        
        return url
    }
    
    static var environment: String {
        #if DEBUG
        return "Development"
        #else
        return "Production"
        #endif
    }
}
