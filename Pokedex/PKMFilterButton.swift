//
//  PKMFilterButton.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit

class PKMFilterButton: UIButton {
    
    var isClicked = false
    var title: String
    
    init(frame: CGRect, title: String) {
        self.title = title
        super .init(frame: frame)
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: "Verdana Bold", size: 16)
        self.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        self.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        self.layer.cornerRadius = 20
    }
    
    // When clicked the isClicked value will change and the background / color of the button reflects the value. 
    
    @objc func click(){
        self.isClicked = !self.isClicked
        UIView.animate(withDuration: 0.2) {
            if (self.isClicked){
                self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            }
            else{
                self.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
