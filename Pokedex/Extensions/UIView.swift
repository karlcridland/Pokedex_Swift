//
//  UIView.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit

extension UIView{
    
    func fadeIn(_ time: TimeInterval) {
        self.alpha = 0
        UIView.animate(withDuration: time) {
            self.alpha = 1
        }
    }
    
    func fadeIn(_ time: TimeInterval, _ completion: @escaping ()->Void) {
        self.alpha = 0
        UIView.animate(withDuration: time) {
            self.alpha = 1
        } completion: { _ in
            completion()
        }
    }
    
}
