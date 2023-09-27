//
//  PokemonDetailsViewModel.swift
//  SwiftUIMVVM
//
//  Created by franklin melo on 26/09/23.
//

import Foundation

protocol PokemonDetailsViewModelDelegate: ObservableObject {
    var pokemon: Pokemon? { get }
    func getPokemon(from url: String) async throws
}

final class PokemonDetailsViewModel: PokemonDetailsViewModelDelegate {
    @Published var pokemon: Pokemon?
    let service: PokedexServicing
    
    init(service: PokedexServicing) {
        self.service = service
    }
    
    @MainActor
    func getPokemon(from url: String) async throws {
        guard let url = URL(string: url) else {
            throw CustomErrors.invalidUrl
        }
        do {
            pokemon = try await service.fetchPokemon(with: url)
        } catch {
            print(error)
        }
    }
}
