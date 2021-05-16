//
//  PKMPokemon.swift
//  PKMPokemon
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import PokemonAPI
import UIKit

extension PKMPokemon{
    
    // Images for pokemon are stored in a static array in the PokedexView, if they aren't present then they're downloaded
    // via the information stored in the pokemons sprites. 
    
    func displayImage(_ picture: UIImageView){
        if let image = PokedexView.images[self.id!]{
            picture.image = image
        }
        else{
            if let basic = self.sprites?.frontDefault, let url = URL(string: basic){
                picture.downloadImage(url: url) { image in
                    PokedexView.images[self.id!] = image
                }
            }
        }
    }
    
    // Returns a view which is used in the search results on the home screen.
    
    func display(frame: CGRect) -> UIView {
        return PKMSearchView(frame: frame, pokemon: self)
    }
    
    // Returns a view which displays the following statistics for a chosen pokemon: name, id, height, weight, type, attack,
    // and moves.
    
    func statisticView(frame: CGRect) -> UIScrollView {
        return PKMStatisticView(frame: frame, pokemon: self)
    }
    
    // Used when initialising the app, adds a dictionary of unique values for the keys type,. When the approptiate filter
    // key is pressed in the PokedexFilters class, the array of Strings built from this method will display.
    
    func addFilters(){
        if PokedexView.filterTypes["type"] == nil{
            PokedexView.filterTypes["type"] = []
        }
        if let filterType = PokedexView.filterTypes["type"]{
            if let types = self.types{
                types.forEach { type in
                    if let name = type.type?.name{
                        if (!filterType.contains(name)){
                            PokedexView.filterTypes["type"]?.append(name)
                        }
                    }
                }
            }
        }
    }
    
    // Method takes a string array input and returns a boolean value based on whether the pokemon has one of every type
    // contained in the array.
    
    func hasType(_ types: [String]) -> Bool {
        var typeCount = 0
        self.types?.forEach { type in
            if let name = type.type?.name{
                if types.contains(name){
                    typeCount += 1
                }
            }
        }
        return typeCount == types.count
    }
    
    // Method returns a string array containing a pokemons type attributes.
    
    func allTypes() -> [String] {
        var temp = [String]()
        self.types?.forEach { type in
            if let name = type.type?.name{
                temp.append(name)
            }
        }
        return temp
    }
    
    // Takes the value of the pokemons primary type and assigns a color based on the value, is used for the background of
    // the statistics view.
    
    func backgroundColor() -> UIColor? {
        if let type = self.types?[0].type?.name{
            switch type{
            case "grass":
                return #colorLiteral(red: 0.6500259638, green: 0.8571230769, blue: 0.5721960664, alpha: 1)
            case "fire":
                return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            case "water":
                return #colorLiteral(red: 0.4065409303, green: 0.5657317042, blue: 0.9404949546, alpha: 1)
            case "poison":
                return #colorLiteral(red: 0.5094960332, green: 0.3945456147, blue: 0.9680580497, alpha: 1)
            case "flying":
                return #colorLiteral(red: 0.6607093811, green: 0.5659486651, blue: 0.9423440099, alpha: 1)
            case "bug":
                return #colorLiteral(red: 0.657341063, green: 0.7198609114, blue: 0.1260197163, alpha: 1)
            case "normal":
                return #colorLiteral(red: 0.6581626534, green: 0.6569408774, blue: 0.4694973826, alpha: 1)
            case "fairy":
                return #colorLiteral(red: 0.9325317144, green: 0.6000199914, blue: 0.6738457084, alpha: 1)
            case "ground":
                return #colorLiteral(red: 0.8777050972, green: 0.7516915202, blue: 0.409412086, alpha: 1)
            case "electric":
                return #colorLiteral(red: 0.9722433686, green: 0.8145003915, blue: 0.188670367, alpha: 1)
            case "fighting":
                return #colorLiteral(red: 0.7352612615, green: 0.4194683135, blue: 0.435788542, alpha: 1)
            case "psychic":
                return #colorLiteral(red: 0.9717376828, green: 0.3461799026, blue: 0.5320883989, alpha: 1)
            case "rock":
                return #colorLiteral(red: 0.7194501758, green: 0.6275401711, blue: 0.2218468487, alpha: 1)
            case "steel":
                return #colorLiteral(red: 0.7224847078, green: 0.7201544642, blue: 0.8156841993, alpha: 1)
            case "ice":
                return #colorLiteral(red: 0.5941720605, green: 0.8459342122, blue: 0.8466081619, alpha: 1)
            case "ghost":
                return #colorLiteral(red: 0.439637363, green: 0.3445366025, blue: 0.5964408517, alpha: 1)
            case "dragon":
                return #colorLiteral(red: 0.6018438935, green: 0.5434277654, blue: 0.9646472335, alpha: 1)
            default:
                return nil
            }
        }
        return nil
    }
    
}
