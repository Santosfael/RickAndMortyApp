//
//  DetailCharacterView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 04/01/26.
//

import SwiftUI

struct DetailCharacterView: View {

    @StateObject var viewModel: CharacterDetailViewModel

    var body: some View {
        NavigationView {
            VStack {
                AsyncImage(url: URL(string: viewModel.character.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 75))
                } placeholder: {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
                Text(viewModel.character.name)
                    .font(.title)
                    .fontWeight(.bold)
                VStack {
                    CharacterDetailItemView(title: "Current status", value: viewModel.character.status, isStatus: true, status: "Dead")
                    CharacterDetailItemView(title: "Species", value: viewModel.character.species)
                    CharacterDetailItemView(title: "Type", value: viewModel.character.type)
                    CharacterDetailItemView(title: "Gender", value: viewModel.character.gender)
                    CharacterDetailItemView(title: "Origin", value: viewModel.character.origin.name)
                    CharacterDetailItemView(title: "Location", value: viewModel.character.location.name)
                    Spacer()
                }
            }
        }
        
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "alive":
            return .green
        case "dead":
            return .red
        default:
            return .gray
        }
    }
}

#Preview {
    DetailCharacterView(viewModel: CharacterDetailViewModel.init(character: Character(id: 361,
                                             name: "Toxic Rick",
                                             status: "Dead",
                                             species: "Homanoid",
                                             type: "Rick's Toxic Side",
                                             gender: "Male",
                                             origin: Origin(name: "Alien Spa",
                                                            url: "https://rickandmortyapi.com/api/location/64"),
                                             location: LocationPerson(name: "Earth",
                                                                url: "https://rickandmortyapi.com/api/location/20"),
                                             image: "https://rickandmortyapi.com/api/character/avatar/361.jpeg",
                                             episode: ["https://rickandmortyapi.com/api/episode/27"],
                                             url: "https://rickandmortyapi.com/api/character/361",
                                             created: "2018-01-10T18:20:41.703Z")))
}
