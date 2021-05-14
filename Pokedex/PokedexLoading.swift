//
//  PokedexLoading.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit

class PokedexLoading: UIView {
    
    private let label: UILabel
    private let loaded = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 4))
    private let maxWidth: CGFloat
    
    override init(frame: CGRect) {
        self.maxWidth = frame.width - 10
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super .init(frame: frame)
        
        let wrapper = UIView(frame: CGRect(x: 5, y: frame.height-15, width: maxWidth, height: 10))
        wrapper.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.addSubview(wrapper)
        
        wrapper.addSubview(loaded)
        self.loaded.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        
        self.addSubview(self.label)
        self.label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.label.textAlignment = .center
        self.label.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.3))
    }
    
    func update(_ percent: CGFloat?) {
        if let percent = percent{
            self.label.text = "loading \(Int(percent))%"
            self.loaded.frame = CGRect(x: 0, y: 0, width: (percent/100)*self.maxWidth, height: 10)
        }
        else{
            self.label.text = "loading 100%"
            self.loaded.frame = CGRect(x: 0, y: 0, width: self.maxWidth, height: 10)
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
            }

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
