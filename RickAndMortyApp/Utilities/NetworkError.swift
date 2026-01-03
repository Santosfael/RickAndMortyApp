//
//  NetworkError.swift
//  RickAndMortyApp
//
//  Created by Rafael on 03/01/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed:
            return "Request Failed"
        case .decodingFailed:
            return "Decoding failed"
        case .unknown:
            return "Unknown error"
        }
    }
}
