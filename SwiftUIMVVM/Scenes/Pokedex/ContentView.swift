//
//  ContentView.swift
//  SwiftUIMVVM
//
//  Created by franklin melo on 14/07/23.
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

struct ContentView<T: PokedexViewModelDelegate>: View {
    @ObservedObject var viewModel: T
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    ForEach(viewModel.filteredPokemons) { value in
                        HStack(spacing: 24) {
                            let url = URL(string: value.sprites.imgUrl)
                            AsyncImage(url: url) {
                                $0.scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(100)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("#\(value.id) \(value.name)").font(.title)
                                
                                TypeView(types: value.types)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.black, lineWidth: 5)
                        )
                        .onTapGesture {
                            print("hello \(value.name)")
                        }
                        Spacer(minLength: 24)
                    }
                }
                .padding(.horizontal, 16)
                .scrollIndicators(.hidden)
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Pokedex")
            .task {
                await viewModel.getAllPokemons(start: 1, limit: 151)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: PokedexViewModel(service: PokedexService()))
    }
}
