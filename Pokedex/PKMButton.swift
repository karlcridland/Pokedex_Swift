//
//  PKMButton.swift
//  Pokedex
//
//  Created by Karl Cridland on 15/05/2021.
//

import Foundation
import UIKit
import PokemonAPI

// Button stores a value of type PKMPokemon, used for the tile pieces a user clicks on in the screen scroll view.

class PKMButton: UIButton{
    let pokemon: PKMPokemon
    init(frame: CGRect, pokemon: PKMPokemon) {
        self.pokemon = pokemon
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
