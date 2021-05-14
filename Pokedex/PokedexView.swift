//
//  PokedexView.swift
//  PokedexView
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit
import PokemonAPI

class PokedexView: UIScrollView {
    
    var pokemon = [PKMPokemon]()
    let screen: PokedexScreen
    let filters: PokedexFilters

    static var filterTypes = [String: [String]]()
    static var images = [Int: UIImage]()
    
    override init(frame: CGRect) {
        
        let margin = CGFloat(20)
        var width = frame.width-(2*margin)
        if (width > 400){
            width = 400
        }
        self.screen = PokedexScreen(frame: CGRect(x: margin, y: margin, width: width, height: width))
        self.screen.center = CGPoint(x: frame.width/2, y: self.screen.center.y)
        self.screen.originalFrame = self.screen.frame
        self.filters = PokedexFilters(frame: CGRect(x: self.screen.frame.minX, y: self.screen.frame.maxY+margin, width: self.screen.frame.width, height: 100))
        
        super .init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 1, green: 0.3696548318, blue: 0.392158068, alpha: 1)
        
        self.addSubview(self.screen)
        self.addSubview(self.filters)
        self.contentSize = CGSize(width: self.frame.width, height: self.filters.frame.maxY+20)
        
        self.screen.pokedex = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private enum pokedexFilter{
    case type
    case stat
}
