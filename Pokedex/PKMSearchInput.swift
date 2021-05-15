//
//  PKMSearchInput.swift
//  Pokedex
//
//  Created by Karl Cridland on 15/05/2021.
//

import Foundation
import UIKit

class PKMSearchInput: UIView, UITextFieldDelegate {
    
    let input: TextField
    var pokedex: PokedexView?
    
    // Dropdown provides the user the ability to search for a pokemon via a string input. 
    
    override init(frame: CGRect) {
        self.input = TextField(frame: CGRect(x: 20, y: frame.height-65, width: frame.width-40, height: 50))
        super .init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.cornerRadius = 8
        self.layer.zPosition = 100
        
        self.input.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.input.layer.cornerRadius = 8
        self.input.font = UIFont(name: "Verdana Bold", size: 16)
        self.input.delegate = self
        self.input.returnKeyType = .done
        self.input.autocorrectionType = .no
        
        let clear = UIButton(frame: CGRect(x: self.frame.width-50, y: self.input.frame.minY+10, width: 30, height: 30))
        clear.addTarget(self, action: #selector(clearInput), for: .touchUpInside)
        clear.setImage(UIImage(named: "cross"), for: .normal)
        self.addSubview(clear)
        
        self.addSubview(clear)
        self.addSubview(self.input)
    }
    
    @objc func clearInput(){
        self.input.text = ""
    }
    
    // Picks up when the value of the input has changed and updates the pokemon displaying to reflect the value.
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        pokedex!.screen.displayPokemon()
        UIView.animate(withDuration: 0.3) {
            if (textField.text?.count == 0){
                self.input.frame = CGRect(x: 20, y: self.frame.height-65, width: self.frame.width-40, height: 50)
            }
            else{
                self.input.frame = CGRect(x: 20, y: self.frame.height-65, width: self.frame.width-80, height: 50)
            }
        }
    }
    
    // Slides the view into place based on the boolean input.
    
    func slide(_ show: Bool){
        UIView.animate(withDuration: 0.3) {
            if !show{
                self.transform = CGAffineTransform.identity
            }
            else{
                self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            }
        }
    }
    
    // Method delegates the enter button on the keyboard's function, in this case it removes the cover and slides the
    // search bar out of view.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let pokedex = self.pokedex{
            pokedex.removeSearch()
        }
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
