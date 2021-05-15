//
//  PKMFilterView.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit

class PKMFilterView: UIView {
    
    var searchFilters = [String]()
    let scroll: UIScrollView
    let screen: PokedexScreen
    var buttons = [PKMFilterButton]()
    
    init(frame: CGRect, screen: PokedexScreen, title: String) {
        self.screen = screen
        self.scroll = UIScrollView(frame: CGRect(x: 5, y: 25, width: frame.width-10, height: frame.height-30))
        super .init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.9673437476, green: 0.8995233774, blue: 0.8149551749, alpha: 1)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 5
        self.layer.borderColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1).withAlphaComponent(0.6).cgColor
        self.alpha = 0
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 30))
        label.text = title
        label.font = UIFont(name: "Verdana Bold", size: 15)
        label.textColor = .black
        self.addSubview(label)
        
        self.addSubview(self.scroll)
    }
    
    // Adds the buttons to the scroll display, adds a target to each button, and updates the content size for the scroll.
    // Also makes sure the filter view is visible.
    
    func updateValues(_ values: [String]?) {
        
        scroll.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
        
        var types = values
        if (values?.count == 0){
            types = PokedexView.filterTypes["type"]
        }
        
        if let values = types{
            var previous: PKMFilterButton?
            values.sorted().forEach { value in
                let button = PKMFilterButton(frame: CGRect(x: 10+(previous?.frame.maxX ?? 5), y: 10, width: 100, height: scroll.frame.height-20), title: value)
                previous = button
                buttons.append(button)
                scroll.addSubview(button)
                scroll.contentSize = CGSize(width: (previous?.frame.maxX)!+15, height: scroll.frame.height)
                button.addTarget(self, action: #selector(updateResults), for: .touchUpInside)
                
                if (searchFilters.contains(value)){
                    button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                    button.click()
                }
                
            }
        }
    }
    
    // Whenever a filter is changed, the displaying pokemon should reflect this. The method to display pokemon with the
    // filtered results is called. Method creates a targetable method for button clicks.
    
    @objc func updateResults(sender: PKMFilterButton) {
        scroll.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        if (sender.isClicked){
            searchFilters.append(sender.title)
        }
        else{
            searchFilters.removeAll(where: {$0 == sender.title})
        }
        screen.displayPokemon()
    }
    
    // Resets the filters so that none are active and clears the array of results by association, and redisplays so that
    // all pokemon are showing again.
    
    func reset() {
        self.buttons.forEach { button in
            button.isClicked = true
            button.click()
        }
        self.searchFilters.removeAll()
        self.updateValues(PokedexView.filterTypes["type"]!)
        self.screen.displayPokemon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
