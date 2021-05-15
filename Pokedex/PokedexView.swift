//
//  PokedexView.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit
import PokemonAPI

class PokedexView: UIScrollView {
    
    var pokemon = [PKMPokemon]()
    let screen: PokedexScreen
    let typeFilter: PKMFilterView
    let title = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
    let clear = UIButton(frame: CGRect(x: 20, y: 20, width: 70, height: 30))

    static var filterTypes = [String: [String]]()
    static var images = [Int: UIImage]()
    
    // Provides the main function for the app, all subviews can be found within the PokedexView, contains the screen
    // variable where a user can swipe through pokemon to choose to view statistics on. When clicked, the screen
    // expands to full size showing the pokemons statistics. The filters variable contains the views which a user
    // interacts with to place a pokemon filter on the screen, narrowing a search result.
    
    override init(frame: CGRect) {
        
        let margin = CGFloat(20)
        let width = [frame.width-(2*margin),CGFloat(400)].min()!
        self.screen = PokedexScreen(frame: CGRect(x: margin, y: margin+50, width: width, height: width))
        self.screen.center = CGPoint(x: frame.width/2, y: self.screen.center.y)
        self.screen.originalFrame = self.screen.frame
        self.typeFilter = PKMFilterView(frame: CGRect(x: self.screen.frame.minX, y: self.screen.frame.maxY+margin, width: self.screen.frame.width, height: 80), screen: self.screen,title: "Type")
        
        super .init(frame: frame)
        
        self.screen.pokedex = self
        self.startUp()
        
    }
    
    // Creates the basic aesthetic for the pokedex, red background to match the original look, a title is added,
    // and the subviews are placed. 
    
    func startUp() {
        self.backgroundColor = #colorLiteral(red: 1, green: 0.368627451, blue: 0.3921568627, alpha: 1)
        self.contentSize = CGSize(width: self.frame.width, height: self.typeFilter.frame.maxY+20)
        self.title.text = "Pokédex"
        self.title.font = UIFont(name: "Verdana Bold Italic", size: 29)
        self.title.textAlignment = .center
        self.title.textColor = .black
        self.addSubview(self.typeFilter)
        self.addSubview(self.title)
        self.addSubview(self.clear)
        self.addSubview(self.screen)
        self.clear.setTitle("reset", for: .normal)
        self.clear.layer.cornerRadius = 15
        self.clear.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.4)
        self.clear.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        self.clear.isHidden = true
    }
    
    @objc func clearClicked(){
        typeFilter.reset()
        self.clear.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
