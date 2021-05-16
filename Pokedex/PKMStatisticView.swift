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
    let segments = UISegmentedControl(items: ["About","Statistics"])
    
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
        stature.text = "1st Edition"
        
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
        
        self.statistics.frame = CGRect(x: 3, y: 253, width: self.frame.width-6, height: self.frame.height-353)
        self.statistics.layer.cornerRadius = 32
        self.statistics.backgroundColor = .white
//        self.statistics.layer.borderWidth = 2
//        self.statistics.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.4).cgColor
        self.statistics.clipsToBounds = true
        self.addSubview(statistics)
        
        self.segments.frame = CGRect(x: self.statistics.frame.width/2-125, y: 35, width: 250, height: 40)
        self.segments.overrideUserInterfaceStyle = .light
        self.segments.backgroundColor = .white
        self.statistics.addSubview(self.segments)
        self.segments.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Verdana Bold", size: 16)!], for: UIControl.State.normal)
        self.segments.addTarget(self, action: #selector(segmenterClicked), for: .valueChanged)
        self.segments.selectedSegmentIndex = 0
        self.segmenterClicked(self.segments)
        
    }
    
    // When the segmenter is clicked, all subviews from the statistics view are remvoved, and a value taken using the
    // segments selected index from the data array are used. The height of the statistics view and the content size
    // are changed based on the subviews contained within the statistics view.
    
    @objc func segmenterClicked(_ sender: UISegmentedControl){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        self.statistics.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        self.statistics.addSubview(self.segments)
        self.statistics.layer.shadowColor = UIColor.black.cgColor
        self.statistics.layer.shadowOpacity = 0.2
        self.statistics.layer.shadowOffset = CGSize(width: 0, height: -10)
        self.statistics.layer.shadowRadius = 10
        
        if (sender.selectedSegmentIndex == 0){
            
            var types = [String]()
            self.pokemon.types?.forEach({ type in
                if let name = type.type?.name{
                    types.append(name)
                }
            })
            self.appendStat(key: "types", value: types.joined(separator: ", "), align: .left)
            self.appendStat(key: "height", value: "\(CGFloat(self.pokemon.height!)/10) m", align: .left)
            self.appendStat(key: "weight", value: "\(CGFloat(self.pokemon.weight!)/10) kg", align: .left)
            var abilities = [String]()
            self.pokemon.abilities?.forEach({ type in
                if let name = type.ability?.name{
                    abilities.append(name)
                }
            })
            self.appendStat(key: "abilities", value: abilities.joined(separator: ", "), align: .left)
            self.appendStat(key: "base exp", value: String(self.pokemon.baseExperience!), align: .left)
            
        }
        else{
            
            self.pokemon.stats?.enumerated().forEach({ (i,stat) in
                if let name = stat.stat?.name, let value = stat.baseStat{
                    self.appendStat(key: name, value: String(value), align: .right)
                }
            })
            
        }
        
        if let bottom = statistics.subviews.sorted(by: {$0.frame.maxY > $1.frame.maxY}).first{
            UIView.animate(withDuration: 0.1) {
                self.statistics.frame = CGRect(x: self.statistics.frame.minX, y: self.statistics.frame.minY, width: self.statistics.frame.width, height: 1000)
                self.contentSize = CGSize(width: self.frame.width, height: self.statistics.frame.minY + bottom.frame.maxY + 20)
                
                
            }
        }
        
    }
    
    // Takes the maximum y value in the statistics view and places two UILabels containing the key and value for example
    // a pokemons height could be 0.7 meters - key: height, value: 0.7 m. If the value is an integer a bar is placed on
    // the screen indicating its value out of 100.
    
    func appendStat(key: String, value: String, align: NSTextAlignment) {
        var y = CGFloat(100)
        if let bottom = statistics.subviews.sorted(by: {$0.frame.maxY > $1.frame.maxY}).first{
            y = bottom.frame.maxY + 10
            if let segment = bottom as? UISegmentedControl{
                y = segment.frame.maxY + 40
            }
        }
        
        let left = UILabel(frame: CGRect(x: 20, y: y, width: 140, height: 40))
        left.text = key
        statistics.addSubview(left)
        left.font = UIFont(name: "Verdana Bold", size: 15)
        left.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        let right = UILabel(frame: CGRect(x: left.frame.maxX, y: y, width: statistics.frame.width-left.frame.maxX-20, height: left.frame.height))
        right.text = value
        right.numberOfLines = 0
        statistics.addSubview(right)
        right.font = UIFont(name: "Verdana Bold", size: 16)
        right.textAlignment = align
        right.textColor = .black
        
        if let n = Int(value), key != "base exp"{
            let bar = UIView(frame: CGRect(x: statistics.frame.width-CGFloat(n)-60, y: y+20, width: CGFloat(n), height: 4))
            bar.backgroundColor = pokemon.backgroundColor()
            statistics.addSubview(bar)
            bar.layer.cornerRadius = 2
            
            bar.layer.shadowColor = UIColor.black.cgColor
            bar.layer.shadowOpacity = 0.3
            bar.layer.shadowOffset = CGSize(width: 0, height: 3)
            bar.layer.shadowRadius = 3
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
