//
//  Card.swift
//  Lecture 1 - Concentration
//
//  Created by Other develoeprs on 2/12/19.
//  Copyright © 2019 Michel Deiman. All rights reserved.
//

import Foundation
struct Card
{ var isFacedUp = false
    var isMatched  = false
    var identifier:Int
    
   static var identifierFactory = 0
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    init(){
self.identifier = Card.getUniqueIdentifier()
    }

}
