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
    let back = UIButton(frame: CGRect(x: 20, y: 20, width: 80, height: 40))
    let pokemonTitle = UILabel(frame: CGRect(x: 100, y: 20, width: UIScreen.main.bounds.width-120, height: 40))
    
    override init(frame: CGRect) {
        self.originalFrame = frame
        self.loadingScreen = PokedexLoading(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super .init(frame: frame)
        self.setUpVisual()
    }
    
    // Sets up how the screen looks and feels: color, border, paging etc.
    
    func setUpVisual() {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.addSubview(self.loadingScreen)
        
        self.clipsToBounds = true
        self.layer.borderWidth = 5
        self.layer.borderColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1).withAlphaComponent(0.6).cgColor
        self.isPagingEnabled = true
        self.delegate = self
        self.backgroundColor = #colorLiteral(red: 0.9673437476, green: 0.8995233774, blue: 0.8149551749, alpha: 1)
        
        self.back.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.back.setTitle("back", for: .normal)
        self.back.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
        self.back.titleLabel!.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.3))
        self.back.layer.cornerRadius = 4
        self.back.addTarget(self, action: #selector(fullscreen), for: .touchUpInside)
        
        self.pokemonTitle.font = UIFont(name: "Verdana Bold", size: 29)
        self.pokemonTitle.textColor = .black
        self.pokemonTitle.textAlignment = .right
    }
    
    // Toggles the screen to fit the size of the window, this is used in cases where the user needs to display extended information.
    
    @objc func fullscreen(sender: UIButton){
        if (!isLoading){
            isFullscreen = !isFullscreen
            UIView.animate(withDuration: 0.3) {
                if (self.isFullscreen){
                    self.tag = Int(self.contentOffset.x)
                    self.layer.cornerRadius = 0
                    self.layer.borderWidth = 0
                    if let superview = self.superview{
                        self.frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: superview.frame.height)
                    }
                    if let pokemon = (sender as? PKMButton)?.pokemon{
                        self.displayPokemonStatistics(pokemon)
                        self.backgroundColor = pokemon.backgroundColor()
                    }
                }
                else{
                    self.layer.cornerRadius = 5
                    self.layer.borderWidth = 5
                    self.frame = self.originalFrame
                    self.backgroundColor = #colorLiteral(red: 0.9673437476, green: 0.8995233774, blue: 0.8149551749, alpha: 1)
                    self.displayPokemon()
                }
            }
            self.contentOffset = CGPoint(x: self.tag, y: 0)
        }
    }
    
    //
    
    func displayPokemonStatistics(_ pokemon: PKMPokemon) {
        UIView.animate(withDuration: 0.3) {
            self.subviews.forEach { subview in
                subview.alpha = 0
            }
        }completion: { _ in
            self.subviews.forEach { subview in
                subview.removeFromSuperview()
            }
            self.contentSize = CGSize(width: 0, height: 0)
            self.addSubview(self.back)
            self.addSubview(self.pokemonTitle)
            self.pokemonTitle.text = pokemon.name
            let statistics = pokemon.statisticView(frame: CGRect(x: 0, y: self.pokemonTitle.frame.maxY+20, width: self.frame.width, height: self.frame.height-(self.pokemonTitle.frame.maxY+20)))
            self.addSubview(statistics)
            statistics.fadeIn(0.3)
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
            display.alpha = 0
            UIView.animate(withDuration: 0.3) {
                display.alpha = 1
            }

            let button = PKMButton(frame: CGRect(x: 0, y: 0, width: display.frame.width, height: self.frame.height), pokemon: pokemon)
            display.addSubview(button)
            button.addTarget(self, action: #selector(fullscreen), for: .touchUpInside)
            
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
