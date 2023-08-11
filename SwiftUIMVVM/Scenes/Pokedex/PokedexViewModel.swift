//
//  PokedexViewModel.swift
//  SwiftUIMVVM
//
//  Created by franklin melo on 14/07/23.
//

import Foundation

protocol PokedexViewModelDelegate: ObservableObject {
    var searchText: String { get set }
    var filteredPokemons: [Pokemon] { get }
    func getAllPokemons(start: Int, limit: Int) async
}

final class PokedexViewModel: PokedexViewModelDelegate {
    @Published var pokemons: [Pokemon] = []
    @Published internal var searchText = ""
    var filteredPokemons: [Pokemon] {
        guard !searchText.isEmpty else { return pokemons }
        
        return pokemons.filter {
            $0.name.lowercased().contains(searchText.lowercased()) || String($0.id).contains(searchText)
        }
    }
    
    let service: PokedexServicing
    
    init(service: PokedexServicing) {
        self.service = service
    }
    
    @MainActor
    func getAllPokemons(start: Int, limit: Int) async {
        await (start...limit).asyncForEach {
            do {
                pokemons.append(try await service.fetchPokemon(with: String($0)))
            } catch {
                print(error)
            }
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
