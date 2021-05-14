//
//  PKMPokemon.swift
//  PKMPokemon
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import PokemonAPI
import UIKit

fileprivate var images = [Int: UIImage]()

extension PKMPokemon{
    
    func display(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 3
        view.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let picture = UIImageView(frame: CGRect(x: 10, y: 20, width: frame.width-20, height: frame.height-45))
        view.addSubview(picture)
        if let image = images[self.id!]{
            picture.image = image
        }
        else{
            if let id = self.id, let url = URL(string: "http://pokeapi.co/media/sprites/pokemon/\(id).png"){
                DispatchQueue.global().async {[weak self] in
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                picture.image = image
                                images[id] = image
                            }
                        }
                    }
                }
                
            }
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: frame.height-25, width: frame.width, height: 20))
        label.textColor = .black
        label.text = self.name
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        label.textAlignment = .center
        view.addSubview(label)
        
        return view
    }
    
}
