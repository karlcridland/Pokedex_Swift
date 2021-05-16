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
    
    // Provides the main function for the app, all subviews can be found within the PokedexView, contains the screen
    // variable where a user can swipe through pokemon to choose to view statistics on. When clicked, the screen
    // expands to full size showing the pokemons statistics. The filters variable contains the views which a user
    // interacts with to place a pokemon filter on the screen, narrowing a search result.
    
    var pokemon = [PKMPokemon]()
    let screen: PokedexScreen
    let typeFilter: PKMFilterView
    let title = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
    let clear = UIButton(frame: CGRect(x: 20, y: 20, width: 70, height: 30))
    let search = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-60, y: 15, width: 40, height: 40))
    let filter = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-100, y: 15, width: 40, height: 40))
    
    let cover = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let searchBar: PKMSearchInput

    static let results = UILabel()
    static let bookmark = UILabel()
    static var filterTypes = [String: [String]]()
    static var images = [Int: UIImage]()
    static var dropdownActive = false
    
    override init(frame: CGRect) {
        
        let margin = CGFloat(20)
        let width = [frame.width-(2*margin),CGFloat(400)].min()!
        self.screen = PokedexScreen(frame: CGRect(x: margin, y: margin+50, width: width, height: width*1.5-10))
        self.screen.center = CGPoint(x: frame.width/2, y: self.screen.center.y)
        self.searchBar = PKMSearchInput(frame: CGRect(x: 0, y: -(80+frame.minY), width: frame.width, height: 80+frame.minY))
        self.typeFilter = PKMFilterView(frame: CGRect(x: 0, y: frame.minY-10, width: frame.width, height: 90), screen: self.screen,title: "Type")
        
        super .init(frame: frame)
        
        self.screen.pokedex = self
        self.searchBar.pokedex = self
        self.startUp()
        
    }
    
    // Creates the basic aesthetic for the pokedex, red background to match the original look, a title is added,
    // and the subviews are placed. 
    
    func startUp() {
        self.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        self.contentSize = CGSize(width: self.frame.width, height: self.typeFilter.frame.maxY+20)
        self.title.text = "Pokédex"
        self.title.font = UIFont(name: "Verdana Bold Italic", size: 29)
        self.title.textAlignment = .center
        self.title.textColor = .white
        
        self.cover.layer.zPosition = 99
        self.cover.isHidden = true
        self.cover.addTarget(self, action: #selector(removeSearch), for: .touchUpInside)
        self.cover.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.1)
        
        self.search.pokedexSearch()
        self.filter.pokedexSearch()
        self.clear.pokedexClear()
        self.search.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        self.filter.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
        self.clear.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        
        self.filter.setImage(UIImage(named: "filter"), for: .normal)
        
        self.searchBar.addSubview(self.typeFilter)
        self.addSubview(self.title)
        self.addSubview(self.clear)
        self.addSubview(self.search)
        self.addSubview(self.filter)
        self.addSubview(PokedexView.results)
        self.addSubview(PokedexView.bookmark)
        self.addSubview(self.screen)
        
        self.screen.center = CGPoint(x: self.screen.center.x, y: ((self.frame.height - self.screen.frame.height)/2)+(self.screen.frame.height/2))
        self.screen.originalFrame = self.screen.frame
        
        [PokedexView.results,PokedexView.bookmark].forEach { label in
            label.frame = CGRect(x: self.screen.frame.minX+10, y: self.screen.frame.maxY+20, width: self.screen.frame.width-20, height: 30)
            label.font = UIFont(name: "Verdana Bold", size: 14)
            label.textColor = .white
        }
        PokedexView.bookmark.textAlignment = .right
        
    }
    
    // Methods slide the dropdown search bar into place, showFilters for the type filters and showSearch for the input
    // search bar. removeSearch clears either as they are both placed on the same super view. The dropdownActive variable
    // is changed to true/false with the intent of the pokemon search tiles fading/appearing based on this result.
    
    @objc func showFilters(){
        searchBar.slide(true)
        ViewController.changeTheme(.light)
        self.cover.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.cover.alpha = 1
        }completion: { _ in
            self.cover.isHidden = false
        }
        self.typeFilter.isHidden = false
        PokedexView.dropdownActive = true
    }
    
    @objc func showSearch(){
        showFilters()
        searchBar.input.becomeFirstResponder()
        self.typeFilter.isHidden = true
    }
    
    @objc func removeSearch(){
        searchBar.slide(false)
        ViewController.changeTheme(.dark)
        searchBar.input.resignFirstResponder()
        self.cover.alpha = 1
        UIView.animate(withDuration: 0.2) {
            self.cover.alpha = 0
        }completion: { _ in
            self.cover.isHidden = true
            PokedexView.dropdownActive = false
        }
    }
    
    // Method clears all filters, both type and input search, hides the clear button and removes any text in the input
    // field.
    
    @objc func clearClicked(){
        searchBar.input.text = ""
        typeFilter.reset()
        self.clear.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Creating the visuals / aesthetic for the two home screen button, the search and the reset buttons.

extension UIButton{
    
    func pokedexSearch() {
        self.isHidden = true
        self.titleLabel?.font = UIFont(name: "Verdana Bold", size: 16)
        self.setImage(UIImage(named: "search"), for: .normal)
    }
    
    func pokedexClear(){
        self.setTitle("reset", for: .normal)
        self.setTitleColor(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), for: .normal)
        self.isHidden = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
        self.titleLabel?.font = UIFont(name: "Verdana Bold", size: 16)
    }
}
