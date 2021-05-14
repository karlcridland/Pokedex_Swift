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
        self.screen = PokedexScreen(frame: CGRect(x: margin, y: margin+50, width: width, height: width))
        self.screen.center = CGPoint(x: frame.width/2, y: self.screen.center.y)
        self.screen.originalFrame = self.screen.frame
        self.filters = PokedexFilters(frame: CGRect(x: self.screen.frame.minX, y: self.screen.frame.maxY+margin, width: self.screen.frame.width, height: 100))
        
        super .init(frame: frame)
        
        self.screen.pokedex = self
        self.startUp()
        
    }
    
    func startUp() {
        self.backgroundColor = #colorLiteral(red: 1, green: 0.368627451, blue: 0.3921568627, alpha: 1)
        self.contentSize = CGSize(width: self.frame.width, height: self.filters.frame.maxY+20)
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 70))
        title.text = "Pokédex"
        title.font = UIFont(name: "Verdana Bold Italic", size: 29)
        title.textAlignment = .center
        title.textColor = .black
        
        self.addSubview(self.filters)
        self.addSubview(title)
        self.addSubview(self.screen)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private enum pokedexFilter{
    case type
    case stat
}
