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
        self.scroll = UIScrollView(frame: CGRect(x: 0, y: 20, width: frame.width, height: frame.height-20))
        super .init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.4)
        self.alpha = 0
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 30))
        label.text = title
        label.font = UIFont(name: "Verdana Bold", size: 15)
        label.textColor = .white
        self.addSubview(label)
        
        self.addSubview(self.scroll)
    }
    
    // Adds the buttons to the scroll display, adds a target to each button, and updates the content size for the scroll.
    // Also makes sure the filter view is visible.
    
    func updateValues(_ values: [String]?) {
        
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
        
        if let values = values{
            var previous: PKMFilterButton?
            values.sorted().forEach { value in
                let button = PKMFilterButton(frame: CGRect(x: 10+(previous?.frame.maxX ?? 0), y: 10, width: 100, height: scroll.frame.height-20), title: value)
                previous = button
                buttons.append(button)
                scroll.addSubview(button)
                scroll.contentSize = CGSize(width: (previous?.frame.maxX)!+10, height: scroll.frame.height)
                button.addTarget(self, action: #selector(updateResults), for: .touchUpInside)
            }
        }
    }
    
    // Whenever a filter is changed, the displaying pokemon should reflect this. The method to display pokemon with the
    // filtered results is called. Method creates a targetable method for button clicks.
    
    @objc func updateResults(sender: PKMFilterButton) {
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
        buttons.forEach { button in
            button.isClicked = true
            button.click()
        }
        searchFilters.removeAll()
        screen.displayPokemon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
