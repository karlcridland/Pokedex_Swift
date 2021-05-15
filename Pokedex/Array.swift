//
//  Array.swift
//  Pokedex
//
//  Created by Karl Cridland on 15/05/2021.
//

import Foundation

extension Array{
    
    // Returns an array of strings with unique values taken from the initial object.
    
    func removeDuplicates() -> [String]? {
        if let strings = self as? [String]{
            var temp = [String]()
            strings.forEach { string in
                if (!temp.contains(string)){
                    temp.append(string)
                }
            }
            return temp
        }
        return nil
    }
    
}
