//
//  UIImageView.swift
//  Pokedex
//
//  Created by Karl Cridland on 14/05/2021.
//

import Foundation
import UIKit

extension UIImageView{
    
    // Downloads the contents of a URL to a UIImageView's image, the UIImage that's retrieved is then called back to the
    // original code. This is used in cases of storing the image to the Pokedex's array of pokemon's images.
    
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
