//
//  PKMScrollView.swift
//  Pokedex
//
//  Created by Karl Cridland on 16/05/2021.
//

import Foundation
import UIKit

class PKMScrollView: UIScrollView, UIScrollViewDelegate {
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.delegate = self
    }
    
    func refresh(){
        let pageNumber = Int((self.contentOffset.x+(self.frame.width/2))/self.frame.width)+1
        let totalPages = Int(self.contentSize.width/self.frame.width)
        PokedexView.bookmark.text = "Page \(pageNumber)/\(totalPages)"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
