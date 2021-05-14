//
//  UIImageView.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit

extension UIImageView{
    
    func downloadImage(url: URL, callback: @escaping (_ image: UIImage)->Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let picture = self{
                            picture.image = image
                        }
                        callback(image)
                    }
                }
            }
        }
    }
}
