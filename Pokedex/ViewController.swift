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
        
        self.view.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if let layout = self.view.superview?.layoutMargins{
            self.pokedex = PokedexView(frame: CGRect(x: 0, y: layout.top, width: self.view.frame.width, height: self.view.frame.height-layout.top-layout.bottom))
            if let pokedex = self.pokedex{
                self.view.addSubview(pokedex)
            }
        }
    }


}
