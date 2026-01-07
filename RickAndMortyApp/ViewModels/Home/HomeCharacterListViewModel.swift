//
//  HomeCharacterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Rafael on 03/01/26.
//

import Foundation
internal import Combine

@MainActor
final class HomeCharacterListViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 1
    @Published var hasMorePages = true
    
    private var isLoadingMore = false
    
    var characterService: CharacterServiceProtocol
    
    init(characterService: CharacterServiceProtocol) {
        self.characterService = characterService
    }
    
    internal func fetchCharacters() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await characterService.fetchCharacters(page: 1)
            characters = response.results
            currentPage = 1
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    internal func loadModeCharacters() async {
        guard hasMorePages, !isLoadingMore else { return }
        isLoadingMore = true
        do {
            let response = try await characterService.fetchCharacters(page: currentPage + 1)
            characters.append(contentsOf: response.results)
            currentPage += 1
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    internal func refreshCharacters() async {
        await fetchCharacters()
    }
}
