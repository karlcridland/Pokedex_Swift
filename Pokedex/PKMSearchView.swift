//
//  PKMSearchView.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit
import PokemonAPI

class PKMSearchView: UIView {
    
    init(frame: CGRect, pokemon: PKMPokemon) {
        super .init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
        
        let picture = UIImageView(frame: CGRect(x: 10, y: 20, width: frame.width-20, height: frame.height-45))
        pokemon.displayImage(picture)
        picture.contentMode = .scaleAspectFit
        self.addSubview(picture)
        
        let label = UILabel(frame: CGRect(x: 0, y: frame.height-30, width: frame.width, height: 20))
        label.textColor = .black
        label.text = pokemon.name
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

