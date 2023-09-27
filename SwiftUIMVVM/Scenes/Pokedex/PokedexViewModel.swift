//
//  PokedexViewModel.swift
//  SwiftUIMVVM
//
//  Created by franklin melo on 14/07/23.
//

import Foundation

protocol PokedexViewModelDelegate: ObservableObject {
    var searchText: String { get set }
    var filteredPokedex: [PokemonList] { get }
    func getPokemonList() async
}

final class PokedexViewModel: PokedexViewModelDelegate {
    @Published var pokedex: Pokedex?
    @Published internal var searchText = ""
    var filteredPokedex: [PokemonList] {
        guard !searchText.isEmpty else { return pokedex?.results ?? [] }
        
        return pokedex?.results.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        } ?? []
    }
    
    let service: PokedexServicing
    
    init(service: PokedexServicing) {
        self.service = service
    }
    
    @MainActor
    func getPokemonList() async {
        do {
            pokedex = try await service.fetchAllPokemons()
        } catch {
            print(error)
        }
    }
}

extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
