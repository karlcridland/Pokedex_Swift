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
    
    private func displayImage(_ picture: UIImageView){
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
    
    func display(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 3
        view.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let picture = UIImageView(frame: CGRect(x: 10, y: 20, width: frame.width-20, height: frame.height-45))
        displayImage(picture)
        picture.contentMode = .scaleAspectFit
        view.addSubview(picture)
        
        let label = UILabel(frame: CGRect(x: 0, y: frame.height-30, width: frame.width, height: 20))
        label.textColor = .black
        label.text = self.name
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
        label.textAlignment = .center
        view.addSubview(label)
        
        return view
    }
    
    // Returns a scroll view which has all statistics available on the pokemon, including type, attack, etc.
    
    func statisticView(frame: CGRect) -> UIScrollView {
        let view = UIScrollView(frame: frame)
        
        let picture = UIImageView(frame: CGRect(x: 20, y: 10, width: frame.width-40, height: 200))
        picture.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.9)
        picture.layer.borderWidth = 3
        picture.contentMode = .scaleAspectFit
        picture.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        self.displayImage(picture)
        view.addSubview(picture)
        
        return view
    }
    
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
    
    func backgroundColor() -> UIColor? {
        if let type = self.types?[0].type?.name{
            switch type{
            case "grass":
                return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            case "fire":
                return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            case "water":
                return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            case "poison":
                return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            case "flying":
                return #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            case "bug":
                return #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
            case "normal":
                return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            case "fairy":
                return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            case "ground":
                return #colorLiteral(red: 0.9373354316, green: 0.8812893033, blue: 0.7283872962, alpha: 1)
            case "electric":
                return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            case "fighting":
                return #colorLiteral(red: 0.726337254, green: 0.471688211, blue: 0.2060503662, alpha: 1)
            case "psychic":
                return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            case "rock":
                return #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
            case "steel":
                return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case "ice":
                return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            case "ghost":
                return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            case "dragon":
                return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            default:
                return nil
            }
        }
        return nil
    }
    
}
