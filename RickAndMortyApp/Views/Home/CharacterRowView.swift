//
//  CharacterRowView.swift
//  RickAndMortyApp
//
//  Created by Rafael on 03/01/26.
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character

    var body: some View {
        VStack( alignment: .center) {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 150)
            }
            
            Text(character.name)
                .font(.headline)
                .foregroundStyle(.black)
            HStack {
                Circle()
                    .fill(statusColor(for: character.status))
                    .frame(width: 10, height: 10)
                Text(character.status)
                    .font(.subheadline)
                    .foregroundStyle(.black)
            }
            Text(character.species)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(maxWidth: 150, minHeight: 200)
        .accessibilityIdentifier("characterCell_\(character.id)")
        .accessibilityLabel("Character: \(character.name)")
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
    CharacterRowView(character: Character(id: 361,
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
                                          created: "2018-01-10T18:20:41.703Z"))
}
