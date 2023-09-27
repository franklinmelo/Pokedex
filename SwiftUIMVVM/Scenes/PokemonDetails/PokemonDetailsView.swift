//
//  PokemonDetailsView.swift
//  SwiftUIMVVM
//
//  Created by franklin melo on 26/09/23.
//

import SwiftUI

struct TypeView: View {
    var types: [PokemonType]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(types) { type in
                Text(type.type.name).padding(6)
                    .background(type.getTypeColor())
                    .cornerRadius(10)
            }
        }
    }
}

struct PokemonDetailsView<T: PokemonDetailsViewModelDelegate>: View {
    @ObservedObject var viewModel: T
    var url: String
    
    var body: some View {
        HStack(spacing: 24) {
            let url = URL(string: viewModel.pokemon?.sprites.imgUrl ?? "")
            AsyncImage(url: url) {
                $0.scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .background(Color.gray.opacity(0.7))
            .cornerRadius(100)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("# \(viewModel.pokemon?.id ?? 0) \(viewModel.pokemon?.name ?? "")").font(.title)
                
                TypeView(types: viewModel.pokemon?.types ?? [])
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.foreground, lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .task {
            do {
                try await viewModel.getPokemon(from: url)
            } catch {
                print(error)
            }
        }
    }
}

struct PokemonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailsView(viewModel: PokemonDetailsViewModel(service: PokedexService()), url: "https://pokeapi.co/api/v2/pokemon/1/")
    }
}
