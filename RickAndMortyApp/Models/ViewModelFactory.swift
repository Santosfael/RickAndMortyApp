//
//  ViewModelFactory.swift
//  RickAndMortyApp
//
//  Created by Rafael on 11/01/26.
//

import Foundation

protocol ViewModelFactory {
    func makeCharacterListViewModel() -> HomeCharacterListViewModel
    func makeLocationListViewModel() -> LocationListViewModel
    func makeEpisodeListViewModel() -> EpisodeListViewModel
}

final class DefaultVieModelFactory: ViewModelFactory {
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func makeCharacterListViewModel() -> HomeCharacterListViewModel {
        return HomeCharacterListViewModel(apiService: apiService)
    }
    
    func makeLocationListViewModel() -> LocationListViewModel {
        return LocationListViewModel(apiService: apiService)
    }
    
    func makeEpisodeListViewModel() -> EpisodeListViewModel {
        return EpisodeListViewModel(apiService: apiService)
    }
}
