//
//  ConfigManager.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

import Foundation

struct ConfigManager {
    static var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            return "https://rickandmortyapi.com/api"
        }
        
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
