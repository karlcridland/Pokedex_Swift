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
        self.view.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
    // Retreives the layout margins for safe use in iPhones X and later, applies this to the PokedexView class and
    // adds it to the view screen.
    
    override func viewDidLayoutSubviews() {
        if let layout = self.view.superview?.layoutMargins, pokedex == nil{
            self.pokedex = PokedexView(frame: CGRect(x: 0, y: layout.top, width: self.view.frame.width, height: self.view.frame.height-layout.top-layout.bottom))
            if let pokedex = self.pokedex{
                self.view.addSubview(pokedex)
                self.downloadPokemon()
            }
        }
    }
    
    // Retrieves all pokemon and stores them in the pokedex array, sorts the array once it's full by the pokemon's
    // id number. The maximum number loaded is 152 as I'm only sorting the first generation of pokemon. The progress
    // bar showing how much has been downloaded is updated each time a pokemon is added to the pokedex through the
    // pokedex's loading screen update method.
    
    func downloadPokemon() {
        
        let cap = 152
        if let pokedex = self.pokedex{
            for i in 1 ... cap{
                pokemonAPI.pokemonService.fetchPokemon(i){ data in
                    switch data{
                    case .success(let pokemon):
                        pokedex.pokemon.append(pokemon)
                        pokemon.addFilters()
                        let queue = DispatchQueue(label: "load")
                        queue.async {
                            DispatchQueue.main.async {
                                if (pokedex.pokemon.count == cap){
                                    if let pokedex = self.pokedex{
                                        pokedex.screen.loadingScreen.update(nil)
                                        pokedex.screen.isLoading = false
                                        pokedex.pokemon = pokedex.pokemon.sorted(by: {$0.id! < $1.id!})
                                        pokedex.screen.displayPokemon()
                                    }
                                }
                                else{
                                    pokedex.screen.loadingScreen.update(CGFloat(pokedex.pokemon.count)*100/CGFloat(152))
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
    }
    
}
