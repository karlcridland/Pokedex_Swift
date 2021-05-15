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
    let back = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-60, y: 20, width: 40, height: 40))
    let pokemonTitle = UILabel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-120, height: 40))
    
    override init(frame: CGRect) {
        self.originalFrame = frame
        self.loadingScreen = PokedexLoading(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super .init(frame: frame)
        self.setUpVisual()
    }
    
    // Sets up the basic features of the screen that only need to be done once at the beginning, including creating the
    // back button that is used to return from full screen. The border, background color, and scroll view set up are
    // completed and then all subviews are added to the super view.
    
    func setUpVisual() {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.addSubview(self.loadingScreen)
        
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 5
        self.layer.borderColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1).withAlphaComponent(0.6).cgColor
        self.clipsToBounds = true
        self.isPagingEnabled = true
        self.delegate = self
        self.backgroundColor = #colorLiteral(red: 0.9673437476, green: 0.8995233774, blue: 0.8149551749, alpha: 1)
        
        self.back.setImage(UIImage(named: "cross"), for: .normal)
        self.back.addTarget(self, action: #selector(fullscreen), for: .touchUpInside)
        
        self.pokemonTitle.font = UIFont(name: "Verdana Bold", size: 29)
        self.pokemonTitle.textColor = .black
    }
    
    // Toggles the screen to fit the size of the window, this is used in cases where the user needs to display extended information
    // such as the pokemons statistics.
    
    @objc func fullscreen(sender: UIButton){
        if (!isLoading){
            isFullscreen = !isFullscreen
            UIView.animate(withDuration: 0.4) {
                if (self.isFullscreen){
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
            
            if (isFullscreen){
                self.tag = Int(self.contentOffset.x)
                self.contentOffset = CGPoint(x: 0, y: 0)
            }
            else{
                self.contentOffset = CGPoint(x: self.tag, y: 0)
            }
            
        }
    }
    
    // Brings up an individual pokemons statistics, before displaying the page, all current views are removed from the
    // page by fading out of view. The content offset is placed to coordinates (0, 0) as the statistics view is being
    // placed on a scroll view that could be at varying x coordinates.
    
    func displayPokemonStatistics(_ pokemon: PKMPokemon) {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        UIView.animate(withDuration: 0.3) {
        }completion: { _ in
            self.contentSize = CGSize(width: 0, height: 0)
            self.addSubview(self.back)
            self.addSubview(self.pokemonTitle)
            self.pokemonTitle.text = pokemon.name
            let statistics = pokemon.statisticView(frame: CGRect(x: 0, y: self.pokemonTitle.frame.maxY+20, width: self.frame.width, height: self.frame.height-(self.pokemonTitle.frame.maxY+20)))
            self.addSubview(statistics)
            statistics.fadeIn(0.2)
        }
    }
    
    // First removes any instance of a UIView from the screen, then displays each pokemon onto the classes scrollview.
    
    func displayPokemon() {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        var i = 0
        filteredPokemon().forEach { pokemon in
            let length = self.frame.width/2
            let display = pokemon.display(frame: CGRect(x: (length*CGFloat(2*(i/4)+(i%2)))+10, y: (length*CGFloat((i/2)%2))+10, width: length-20, height: length-20))
            self.addSubview(display)
            display.transform = CGAffineTransform(translationX: [5,-5,5,-5][i%4], y: [5,5,-5,-5][i%4])
            display.alpha = 0
            UIView.animate(withDuration: 0.3) {
                display.alpha = 1
            }

            let button = PKMButton(frame: CGRect(x: 0, y: 0, width: display.frame.width, height: self.frame.height), pokemon: pokemon)
            display.addSubview(button)
            button.addTarget(self, action: #selector(fullscreen), for: .touchUpInside)
            i += 1
            
            self.contentSize = CGSize(width: CGFloat((i+3)/4)*self.frame.width, height: self.frame.height)
        }
    }
    
    // Returns all the pokemon that fit the criterea a user has inputted. Criteria include: filtering through the type of
    // pokemon, and the a string taken from the search input. If the pokemon meets criterea then it is added to the
    // PKMPokemon array which is returned at the end of the function. Before the return statement, the types of the
    // pokemon in the array of looped through and their types are sorted into an array to show all available types
    // based on the current selection if a user would need to further narrow down a search.
    
    func filteredPokemon() -> [PKMPokemon] {
        
        var results = [PKMPokemon]()
        
        if let pokedex = self.pokedex{
            let typeFilters = pokedex.typeFilter.searchFilters
            pokedex.pokemon.forEach { pokemon in
                var proceed = true
                if typeFilters.count > 0 && !pokemon.hasType(typeFilters){
                    proceed = false
                }
                if let search = pokedex.searchBar.input.text, proceed == true{
                    if (search.count > 0){
                        proceed = pokemon.name!.lowercased().contains(search.lowercased())
                    }
                }
                if (proceed){
                    results.append(pokemon)
                }
            }
            pokedex.clear.isHidden = typeFilters.count == 0 && pokedex.searchBar.input.text!.count == 0
        }
        
        var typesRemaining = [String]()
        results.forEach { result in
            result.allTypes().forEach { type in
                typesRemaining.append(type)
            }
        }
        if let unique = typesRemaining.removeDuplicates(){
            pokedex?.typeFilter.updateValues(unique)
        }
        
        return results
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
