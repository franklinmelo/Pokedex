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
    func fetchAllPokemons(completion: @escaping (Result<Pokedex, Error>) -> Void)
    func fetchPokemon(with id: String) async throws -> Pokemon
}

final class PokedexService: PokedexServicing {
    func fetchAllPokemons(completion: @escaping (Result<Pokedex, Error>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=151") else { return }
        let urlRequest = URLRequest(url: url)
        URLSession(configuration: .default).dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(CustomErrors.dataNil))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(Pokedex.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    func fetchPokemon(with id: String) async throws -> Pokemon {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/") else {
            throw CustomErrors.invalidUrl
        }
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

