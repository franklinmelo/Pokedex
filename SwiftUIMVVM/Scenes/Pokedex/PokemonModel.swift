//
//  PokemonModel.swift
//  SwiftUIMVVM
//
//  Created by franklin melo on 14/07/23.
//

import Foundation
import SwiftUI

struct Pokedex: Decodable {
    let results: [PokemonList]
}

struct PokemonList: Decodable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
    }
}

struct Pokemon: Decodable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let sprites: PokemonImage
    let types: [PokemonType]
}


struct PokemonImage: Decodable {
    let imgUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imgUrl = "front_default"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imgUrl = try container.decode(String.self, forKey: .imgUrl)
    }
}

struct PokemonType: Decodable, Identifiable {
    enum TypeColors: String {
        case normal
        case fire
        case water
        case grass
        case flying
        case fighting
        case poison
        case electric
        case ground
        case rock
        case ice
        case bug
        case ghost
        case steel
        case dragon
        case dark
        case fairy
        case psychic
    }
    
    var id = UUID()
    let type: TypeDetail
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(TypeDetail.self, forKey: .type)
    }
    
    struct TypeDetail: Decodable {
        let name: String
    }
    
    func getTypeColor() -> Color {
        guard let type = TypeColors(rawValue: type.name) else { return .white }
        switch type {
        case .normal:
            return .init(red: 168/255, green: 167/255, blue: 122/255)
        case .fire:
            return .init(red: 238/255, green: 129/255, blue: 48/255)
        case .water:
            return .init(red: 99/255, green: 144/255, blue: 240/255)
        case .grass:
            return .init(red: 122/255, green: 199/255, blue: 76/255)
        case .flying:
            return .init(red: 169/255, green: 143/255, blue: 243/255)
        case .fighting:
            return .init(red: 194/255, green: 46/255, blue: 40/255)
        case .poison:
            return .init(red: 163/255, green: 62/255, blue: 161/255)
        case .electric:
            return .init(red: 247/255, green: 208/255, blue: 44/255)
        case .ground:
            return .init(red: 226/255, green: 191/255, blue: 101/255)
        case .rock:
            return .init(red: 182/255, green: 161/255, blue: 54/255)
        case .ice:
            return .init(red: 150/255, green: 217/255, blue: 214/255)
        case .bug:
            return .init(red: 168/255, green: 185/255, blue: 26/255)
        case .ghost:
            return .init(red: 115/255, green: 87/255, blue: 151/255)
        case .steel:
            return .init(red: 183/255, green: 183/255, blue: 206/255)
        case .dragon:
            return .init(red: 111/255, green: 53/255, blue: 252/255)
        case .dark:
            return .init(red: 112/255, green: 87/255, blue: 70/255)
        case .fairy:
            return .init(red: 214/255, green: 133/255, blue: 173/255)
        case .psychic:
            return .init(red: 249/255, green: 85/255, blue: 135/255)
        }
    }
}
