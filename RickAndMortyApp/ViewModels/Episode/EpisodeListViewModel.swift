//
//  EpisodeListViewModel.swift
//  RickAndMortyApp
//
//  Created by Rafael on 06/01/26.
//

import Foundation
internal import Combine

// @MainActor: garante que TODAS as atualizações de UI aconteçam na thread principal
// Isso evita crashes e problemas de sincronização
@MainActor
final class EpisodeListViewModel: ObservableObject {

    // @Published: quando a propriedade muda, notifica automaticamente as Views
    // As Views que observam esse ViewModel serão re-renderizadas
    @Published var episodes: [Episode] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 1
    @Published var hasMorePages = true
    
    private var isLoadingMore = false
    
    private var apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    internal func fetchEpisodes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiService.fetchEpisodes(page: 1)
            episodes = response.results
            currentPage = 1
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    internal func loadMoreEpisodes() async {
        guard hasMorePages, !isLoading else { return }
        
        isLoadingMore = true
        
        do {
            let response = try await apiService.fetchEpisodes(page: currentPage + 1)
            episodes.append(contentsOf: response.results)
            currentPage += 1
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    internal func refreshLocations() async {
        await fetchEpisodes()
    }
}
