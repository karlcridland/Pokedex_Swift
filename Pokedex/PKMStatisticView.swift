//
//  PKMStatisticView.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit
import PokemonAPI

class PKMStatisticView: UIScrollView {
    
    let statistics = UITextView()
    
    init(frame: CGRect, pokemon: PKMPokemon) {
        super .init(frame: frame)
        
        let picture = UIImageView(frame: CGRect(x: 20, y: 10, width: frame.width-40, height: 200))
        picture.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.9)
        picture.layer.borderWidth = 3
        picture.contentMode = .scaleAspectFit
        picture.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        pokemon.displayImage(picture)
        self.addSubview(picture)
        
        let underPicture = UIView(frame: CGRect(x: picture.frame.minX, y: picture.frame.maxY-3, width: picture.frame.width, height: 26))
        self.addSubview(underPicture)
        underPicture.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        underPicture.layer.borderWidth = 3
        underPicture.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        let identification = UILabel(frame: CGRect(x: 10, y: 3, width: 80, height: 20))
        if let id = pokemon.id{
            identification.text = "no. \(id)"
        }
        identification.font = UIFont(name: "Verdana Bold Italic", size: 12)
        identification.textColor = .black
        underPicture.addSubview(identification)
        
        let stature = UILabel(frame: CGRect(x: underPicture.frame.width-293, y: 3, width: 280, height: 20))
        if let weight = pokemon.weight, let height = pokemon.height{
            stature.text = "height: \(height) / weight: \(weight)"
        }
        stature.font = UIFont(name: "Verdana Bold Italic", size: 12)
        stature.textColor = .black
        stature.textAlignment = .right
        underPicture.addSubview(stature)
        
        statistics.frame = CGRect(x: 20, y: underPicture.frame.maxY+20, width: picture.frame.width, height: self.frame.height-underPicture.frame.maxY-40)
        statistics.layer.cornerRadius = 8
        statistics.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.4)
        statistics.font = UIFont(name: "Verdana Bold", size: 16)
        statistics.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.addSubview(statistics)
        
        var text = ""
        let values = ["types":pokemon.types as Any,"abilities":pokemon.abilities as Any,"moves":pokemon.moves as Any]
            
        ["types","abilities","moves"].forEach { key in
            let values = values[key]!
            text += "\(key): \(sortStatistics(values).joined(separator: ", "))\n\n"
        }
        statistics.text = text
        if (statistics.contentSize.height < statistics.frame.height){
            statistics.frame = CGRect(x: 20, y: underPicture.frame.maxY+20, width: picture.frame.width, height: statistics.contentSize.height)
        }
    }
    
    private func sortStatistics(_ input: Any) -> [String]{
        var stats = [String]()
        
        switch input{
        case is [PKMPokemonType]:
            (input as! [PKMPokemonType]).forEach { stat in
                if let name = stat.type?.name{
                    stats.append(name)
                }
            }
            break
        case is [PKMPokemonMove]:
            (input as! [PKMPokemonMove]).forEach { stat in
                if let name = stat.move?.name{
                    stats.append(name)
                }
            }
            break
        case is [PKMPokemonAbility]:
            (input as! [PKMPokemonAbility]).forEach { stat in
                if let name = stat.ability?.name{
                    stats.append(name)
                }
            }
            break
        default:
            break
        }
        
        return stats
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
