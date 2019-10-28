//  ViewController.swift
//  Concentration
//
//  Coding as done by Instructor CS193P Michel Deiman on 11/11/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    lazy var game = Concentration(numberOfPairsOfCard: (cardButtons.count + 1) / 2 )
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            // print(ca)
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    func updateViewFromModel()
    {
        if cardButtons != nil{
            for index in cardButtons.indices
            {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFacedUp
                {
                    button.setTitle(emoji(for : card), for:  UIControl.State.normal)
                    button.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
                else
                {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                }
                
            }
        }
    }
    var theme: [String]?
    {didSet{
        emojiChoices = theme ?? [""]
        emoji = [:]
        updateViewFromModel()
        }
        
    }
    var emojiChoices = ["😀","😌","😎","🤓","😠","😤","😭","😰","😱","😳","😜","😇"]
     var emoji = [Int : String]()
    func emoji(for card : Card) -> String
    {
        if emoji[card.identifier] == nil , emojiChoices.count > 0
        {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at:randomIndex)
        }
        return emoji[card.identifier] ?? "$"
    }
}
