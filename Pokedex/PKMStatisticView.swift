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
    
    // Called when a user has clicked on a Pokemon tile to access more information about a specific pokemon, this view is
    // displayed in full screen.
    
    let statistics = UIView()
    let pokemon: PKMPokemon
    
    init(frame: CGRect, pokemon: PKMPokemon) {
        self.pokemon = pokemon
        super .init(frame: frame)
        
        self.setUpPicture()
        self.setUpStatistics()
    }
    
    // A picture is displayed, along with a caption stating the pokemon's index number, it's height, and weight.
    
    private func setUpPicture() {
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
        
        let stature = UILabel(frame: CGRect(x: underPicture.frame.width-293, y: 3, width: 280, height: 20))
        if let weight = pokemon.weight, let height = pokemon.height{
            stature.text = "height: \(height) / weight: \(weight)"
        }
        
        stature.textAlignment = .right
        [identification,stature].forEach { label in
            label.font = UIFont(name: "Verdana Bold Italic", size: 12)
            label.textColor = .black
            underPicture.addSubview(label)
        }
    }
    
    // Statistics are provided in the statistics view, these include the pokemon's abilities, types, and moves. A
    // UISegmentedControl is implemented so the user can navigate between them. If the segments appear further than
    // the bounds of the screen then the content size is adjusted to reflect this allowing the user to scroll.
    
    private func setUpStatistics(){
        
        self.statistics.frame = CGRect(x: 20, y: 313, width: frame.width-40, height: self.frame.height-353)
        self.addSubview(statistics)
        
        let segments = UISegmentedControl(items: ["types","abilities","moves"])
        segments.frame = CGRect(x: 20, y: 253, width: frame.width-40, height: 40)
        segments.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.4)
        self.addSubview(segments)
        segments.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Verdana Bold", size: 16)!], for: UIControl.State.normal)
        segments.addTarget(self, action: #selector(segmenterClicked), for: .valueChanged)
        segments.selectedSegmentIndex = 0
        self.segmenterClicked(segments)
        
    }
    
    // When the segmenter is clicked, all subviews from the statistics view are remvoved, and a value taken using the
    // segments selected index from the data array are used. 
    
    @objc func segmenterClicked(_ sender: UISegmentedControl){
        if sender.userActivity?.activityType != .none{
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        self.statistics.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        let data = [pokemon.types! as [Any],pokemon.abilities! as [Any],pokemon.moves! as [Any]]
        let values = self.retrieveStatistics(data[sender.selectedSegmentIndex])
        values.enumerated().forEach { (i,value) in
            let background = UIView(frame: CGRect(x: 0, y: CGFloat(i)*60, width: self.statistics.frame.width, height: 50))
            background.layer.cornerRadius = 8
            background.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.4)
            background.layer.borderWidth = 2
            background.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.4).cgColor
            statistics.addSubview(background)
            
            let label = UILabel(frame: CGRect(x: 20, y: 0, width: background.frame.width-40, height: 50))
            label.text = value
            background.addSubview(label)
            label.font = UIFont(name: "Verdana Bold", size: 15)
            
            self.statistics.frame = CGRect(x: self.statistics.frame.minX, y: self.statistics.frame.minY, width: self.statistics.frame.width, height: background.frame.maxY+20)
            self.contentSize = CGSize(width: self.frame.width, height: self.statistics.frame.maxY)
            
        }
        
    }
    
    // Sorts the data into a string array based on the statistics type.
    //
    // !! PKMNamedAPIResource shared type may be a way to make the code cleaner ??
    
    private func retrieveStatistics(_ input: Any) -> [String]{
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
        
        return stats.suffix(8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
