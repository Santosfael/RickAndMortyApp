//
//  HomeCharacterListView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 03/01/26.
//

import SwiftUI

struct HomeCharacterListView: View {
    @StateObject var viewModel: CharacterListViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.characters.isEmpty && !viewModel.isLoading {
                    Text("No characters found")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.characters) { character in
                                
                                
                                NavigationLink(destination: DetailCharacterView(viewModel: CharacterDetailViewModel(character: character))) {
                                    CharacterRowView(character: character)
                                        .onAppear {
                                            if character.id == viewModel.characters.last?.id {
                                                Task {
                                                    await viewModel.loadModeCharacters()
                                                }
                                            }
                                        }
                                }
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.refreshCharacters()
                    }
                }
                
                if viewModel.isLoading && viewModel.characters.isEmpty {
                    ProgressView("Loading...")
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Rick & Morty")
            .alert(item: Binding<AlertItem?>(
                get: { viewModel.errorMessage != nil ? AlertItem(message: viewModel.errorMessage!) : nil },
                set: { _ in viewModel.errorMessage = nil }
            )) { alertItem in
                Alert(title: Text("Error"), message: Text(alertItem.message), dismissButton: .default(Text("OK")))
            }
            .task {
                await viewModel.fetchCharacters()
            }
        }
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}

#Preview {
    HomeCharacterListView(viewModel: CharacterListViewModel(characterService: CharacterService()))
}
