//
//  PokedexScreen.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit
import PokemonAPI

class PokedexScreen: UIScrollView, UIScrollViewDelegate {
    
    var pokedex: PokedexView?
    
    var isFullscreen = false
    var originalFrame: CGRect
    
    var isLoading = true
    var loadingScreen: PokedexLoading
    
    override init(frame: CGRect) {
        self.originalFrame = frame
        self.loadingScreen = PokedexLoading(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super .init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.addSubview(self.loadingScreen)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderWidth = 5
        self.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.isPagingEnabled = true
        self.delegate = self
        
    }
    
    // Toggles the screen to fit the size of the window, this is used in cases where the user needs to display extended information.
    
    @objc func fullscreen(){
        if (!isLoading){
            isFullscreen = !isFullscreen
            UIView.animate(withDuration: 0.3) {
                if (self.isFullscreen){
                    if let superview = self.superview{
                        self.frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: superview.frame.height)
                    }
                    self.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                }
                else{
                    self.frame = self.originalFrame
                    self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    // First removes any instance of a UIView from the screen, then displays each pokemon onto the classes scrollview.
    
    func displayPokemon() {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        filteredPokemon().enumerated().forEach { (i, pokemon) in
            let length = self.frame.width/2
            let display = pokemon.display(frame: CGRect(x: (length*CGFloat(2*(i/4)+(i%2)))+10, y: (length*CGFloat((i/2)%2))+10, width: length-20, height: length-20))
            self.addSubview(display)
            self.contentSize = CGSize(width: display.frame.maxX+10, height: self.frame.height)
            display.transform = CGAffineTransform(translationX: [5,-5,5,-5][i%4], y: [5,5,-5,-5][i%4])
            
        }
        
    }
    
    // Returns all the pokemon that fit the criterea a user has inputted.
    
    func filteredPokemon() -> [PKMPokemon] {
        var result = [PKMPokemon]()
        if let pokedex = self.pokedex{
            pokedex.pokemon.forEach { pokemon in
                result.append(pokemon)
            }
        }
        return result
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
