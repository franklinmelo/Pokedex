//
//  ContentView.swift
//  SwiftUIMVVM
//
//  Created by franklin melo on 14/07/23.
//

import SwiftUI

struct TView: View {
    var body: some View {
        Text("Present").padding(6)
            .background(.red)
            .cornerRadius(10)
    }
}

struct ContentView<T: PokedexViewModelDelegate>: View {
    @ObservedObject var viewModel: T
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(Array(viewModel.filteredPokedex.enumerated()), id: \.offset) { id, value in
                        NavigationLink {
                            // destination view to navigation to
                            PokemonDetailsView(viewModel: PokemonDetailsViewModel(service: PokedexService()), url: value.url)
                        } label: {
                            HStack(spacing: 16) {
                                Text("# \(String(format: "%03d", id + 1))")
                                    .font(.title3.bold())
                                Image(systemName: "gamecontroller")
                                Text(value.name)
                                    .font(.title3.bold())
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            .toolbar {
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                    Text("Present navigation")
                }
                .sheet(isPresented: $showSheet) {
                    TView()
                }
                .buttonStyle(.plain)
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Pokedex")
            .task {
                await viewModel.getPokemonList()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: PokedexViewModel(service: PokedexService()))
    }
}
