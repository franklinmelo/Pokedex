//
//  PokedexService.swift
//  SwiftUIMVVM
//
//  Created by franklin melo on 14/07/23.
//

import Foundation

enum CustomErrors: Error {
    case dataNil
    case invalidUrl
    case responseError(code: Int)
}

protocol PokedexServicing {
    func fetchAllPokemons() async throws -> Pokedex
    func fetchPokemon(with url: URL) async throws -> Pokemon
}

final class PokedexService: PokedexServicing {
    func fetchAllPokemons() async throws -> Pokedex {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=151") else {
            throw CustomErrors.invalidUrl
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let resp = response as? HTTPURLResponse, resp.statusCode >= 300 {
                throw CustomErrors.responseError(code: resp.statusCode)
            }
            
            let model = try JSONDecoder().decode(Pokedex.self, from: data)
            return model
        } catch {
            throw error
        }
    }
    
    func fetchPokemon(with url: URL) async throws -> Pokemon {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let resp = response as? HTTPURLResponse, resp.statusCode >= 300 {
                throw CustomErrors.responseError(code: resp.statusCode)
            }
            
            let model = try JSONDecoder().decode(Pokemon.self, from: data)
            return model
        } catch {
            throw error
        }
    }
}

