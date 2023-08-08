//
//  SwiftUIMVVMApp.swift
//  SwiftUIMVVM
//
//  Created by franklin melo on 14/07/23.
//

import SwiftUI

@main
struct SwiftUIMVVMApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: PokedexViewModel(service: PokedexService()))
        }
    }
}
