//
//  PokedexView.swift
//  PokedexView
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit
import PokemonAPI

class PokedexView: UIView {
    
    var pokemon = [Int: PKMPokemon]()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private enum pokedexFilter{
    case type
    case stat
}
