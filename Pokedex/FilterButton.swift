//
//  FilterButton.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit

class FilterButton: UIView {
    let button: UIButton
    init(frame: CGRect, title: String) {
        self.button = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super .init(frame: frame)
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.width-40, height: self.frame.height/3))
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 0.3))
        self.addSubview(label)
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
