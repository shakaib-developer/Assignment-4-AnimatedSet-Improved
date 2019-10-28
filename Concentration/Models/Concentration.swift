//
//  Concentration.swift
//  Lecture 1 - Concentration
//
//  Created by Other develoeprs on 2/12/19.
//  Copyright © 2019 Michel Deiman. All rights reserved.d
//

import Foundation

class Concentration
{
    var cards = [Card]()
    var indexOfOnlyOneAndOnlyFaceUpCard : Int?
  /////choose card func//8*************
    func chooseCard(at index : Int)
    {
        if !cards[index].isMatched
        {
            if let matchIndex  = indexOfOnlyOneAndOnlyFaceUpCard, matchIndex != index
            {
                if cards[matchIndex].identifier == cards[index].identifier
                {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                cards[index].isFacedUp = true
                indexOfOnlyOneAndOnlyFaceUpCard = nil
             }
            else
            {
                for flipDown in self.cards.indices
            
                {
                cards[flipDown].isFacedUp = false
                
                }
                cards[index].isFacedUp  = true
                indexOfOnlyOneAndOnlyFaceUpCard = index
                
            }
        }
    }
    
    /////init of Concentration
    init(numberOfPairsOfCard : Int) {
        
        for _ in 1...numberOfPairsOfCard
        {
        let card = Card()
            cards += [card , card]
        }
        
        cards.shuffle()
    }
}
