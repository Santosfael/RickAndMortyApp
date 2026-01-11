//
//  EpisodeListView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 11/01/26.
//

import SwiftUI

struct EpisodeListView: View {
    @StateObject private var viewModel: EpisodeListViewModel
    
    init(viewModel: EpisodeListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.episodes.isEmpty && !viewModel.isLoading {
                    Text("No episodes found")
                        .foregroundStyle(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.episodes) { episode in
                                EpisodeRowView(episode: episode)
                                    .padding(.horizontal)
                                    .onAppear {
                                        if episode.id == viewModel.episodes.last?.id {
                                            Task {
                                                await viewModel.loadMoreEpisodes()
                                            }
                                        }
                                    }
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await viewModel.refreshLocations()
                    }
                }
                
                if viewModel.isLoading && viewModel.episodes.isEmpty {
                    ProgressView("Loading episodes...")
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Episodes")
            .alert(item: Binding<AlertItem?>(
                get: { viewModel.errorMessage != nil ? AlertItem(message: viewModel.errorMessage!) : nil },
                set: { _ in viewModel.errorMessage = nil }
            )) { alertItem in
                Alert(title: Text("Error"),
                      message: Text(alertItem.message),
                      dismissButton: .default(Text("OK"))
                )
            }
            .task {
                await viewModel.fetchEpisodes()
            }
        }
    }
}

#Preview {
    EpisodeListView(viewModel: EpisodeListViewModel(apiService: APIService()))
}
