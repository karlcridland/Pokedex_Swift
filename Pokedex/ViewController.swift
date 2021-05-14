//
//  ViewController.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import UIKit
import PokemonAPI

class ViewController: UIViewController {

    let pokemonAPI = PokemonAPI()
    var pokedex: PokedexView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if let layout = self.view.superview?.layoutMargins, pokedex == nil{
            self.pokedex = PokedexView(frame: CGRect(x: 0, y: layout.top, width: self.view.frame.width, height: self.view.frame.height-layout.top-layout.bottom))
            if let pokedex = self.pokedex{
                self.view.addSubview(pokedex)
                self.downloadPokemon()
            }
        }
    }
    
    // Retrieves all pokemon and stores them in the pokedex array.
    
    func downloadPokemon() {
        
        var tempPokemon = [Int:PKMPokemon]()
        let cap = 152
        
        for i in 1 ... cap{
            pokemonAPI.pokemonService.fetchPokemon(i){ data in
                switch data{
                case .success(let pokemon):
                    tempPokemon[i] = pokemon
                    pokemon.addFilters()
                    let queue = DispatchQueue(label: "load")
                    queue.async {
                        DispatchQueue.main.async {
                            if (tempPokemon.keys.count == cap){
                                if let pokedex = self.pokedex{
                                    pokedex.screen.loadingScreen.update(nil)
                                    pokedex.screen.isLoading = false
                                    pokedex.pokemon = self.handlePokemon(tempPokemon)
                                    pokedex.screen.displayPokemon()
                                }
                            }
                            else{
                                self.pokedex?.screen.loadingScreen.update(CGFloat(tempPokemon.keys.count)*100/CGFloat(152))
                            }
                        }
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Sorts the dictionary into key value (index of pokemon) and arranges them in an array.

    func handlePokemon(_ input: [Int:PKMPokemon]) -> [PKMPokemon]{
        var temp = [PKMPokemon]()
        input.keys.sorted().forEach { i in
            if let pokemon = input[i]{
                temp.append(pokemon)
            }
        }
        return temp
    }
    
}
