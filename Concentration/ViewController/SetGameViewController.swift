//
//  ViewController.swift
//  SetCardGame
//
//  Created by Other develoeprs on 2/14/19.
//  Copyright © 2019 Other develoeprs. All rights reserved.
//
import UIKit

class SetGameViewController: UIViewController ,traitFrameChange {
    lazy var animator = UIDynamicAnimator(referenceView: playingFieldView )
    var cardBehavior = CardBehavior()
    var cardsface = CardFaces()
    var cardlist  = [Int]()
    var cardWithFaces = 0
    var gameOfSet = SetCardGame()
    
    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet weak var playingFieldView: MainView!{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
            playingFieldView.addGestureRecognizer(tap)
        }
    }
    //////////////////////----------------------------ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        playingFieldView.frameChangeDelegate = self
        startNewGame()
    }
    
    //////////////////----------------------------staringScreen
    func startingScreen()
    {
        let numberOfCards = 12
        drawCardsFromDeck(byCountOf: numberOfCards)
        _ = Timer.scheduledTimer(withTimeInterval: Double(numberOfCards) * Constants.timeIntervel, repeats: false)
        {   timer in
            self.newGameStart.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.EnableButtons(enable: true)
        }
    }
    
    ///////////---------------------------------drawCardsFromDeck
    func drawCardsFromDeck(byCountOf count : Int)
    {
       
        var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardRatio ),frame:playingFieldView.bounds)
        grid.cellCount = cardWithFaces + count
        ///////////count is alomst every time 3
        for index in 0...count-1
        {
            _ = Timer.scheduledTimer(withTimeInterval: Constants.timeIntervel * Double(index),repeats: false)
            {
                timer in
                grid.frame = self.playingFieldView.bounds
                self.drawOneCardFromDeck( frameGrid: grid[self.cardWithFaces ]!)
            }
        }
    }
    //------------------------------------------------------removeSet()
    func removeSet( cardList : [Int])
    {
        var discardedDeckFrame =    scoreLable.frame
        
        for index in 0...2
        {
            _ = Timer.scheduledTimer(withTimeInterval: Constants.timeIntervel * Double(index), repeats: false)
            { timer in
               // let indexs = cardList[index]
                discardedDeckFrame.origin = CGPoint(
                    x: self.playingFieldView.bounds.maxX  - self.scoreLable.frame.size.width ,
                    y:  self.playingFieldView.bounds.maxY)
                self.playingFieldView.frameOfCard(at: cardList[index], discardedDeckFrame)
            }
        }
        _ = Timer.scheduledTimer(withTimeInterval: Constants.timeIntervel * 3 , repeats: false)
        { timer in
            self.deleteCards(cardList)
        }
    }
    ////////--------------------------deleteCards
    func deleteCards( _ cardList: [Int]){
        var listOfCard =  cardList
        for _ in 0...2
        {
            let max = listOfCard.max()!
            self.playingFieldView.cardDraw[max].alpha = 0
            self.playingFieldView.cardDraw.remove(at: max)
            cardWithFaces -= 1
            listOfCard[ listOfCard.firstIndex(of: max)!] = -1
        }
        if cardsface.isArrayEmpty()
        {
            defineCardFrame(playingFieldView.bounds)
        }
    }
    ///////////////---------------------------drawOneCardFromDeck()
    func drawOneCardFromDeck(  frameGrid : CGRect)
    {
        if(!cardsface.isArrayEmpty() ){
            let index = cardWithFaces
            AttributingCardFaces( index : index)
            cardWithFaces += 1
            playingFieldView.frameOfBlankCard(at: index, frameGrid, deckFrame: deck.frame)
            playingFieldView.addCardAsSubview(at: index, frameGrid)
        }
    }
    ///////////----------------------------changingSetOfCard
    func  changingSetOfCards(_ cardlist: [Int],framesOfMatchedCards: [CGRect] )
    {
        
        removeSet(cardList:  cardlist)
        
        if !cardsface.isArrayEmpty()
        {
            for index in 0...2
            {
                _ = Timer.scheduledTimer(withTimeInterval: 2 + (Constants.timeIntervel * Double(index)), repeats: false)
                {
                    timer in
                    self.drawOneCardFromDeck(  frameGrid :framesOfMatchedCards[index])
                }
            }
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: Constants.timeIntervel * 6 , repeats: false)
        {timer in
            self.EnableButtons(enable: true)
        }
        
    }
    @IBOutlet weak var newGameStart: UIButton!
    /////////--------------------------------------------updateView
    func  updateView(ifMatched  matched : Bool)
        
    {     scoreLable.text = "Set: \(gameOfSet.set)"
        for index in  0...2
        {
            playingFieldView.cardSelection(click: false, on: cardlist[index])///////
        }
        if matched
        { 
            let cardlists = cardlist
            var framesOfMatchedCards = [CGRect]()
            EnableButtons(enable: false)
            //            deck.isEnabled = false
            //            newGameStart.isEnabled = false
            animator.addBehavior(cardBehavior)
            
            for indexOfList in 0...2
            {
                let cardView = self.playingFieldView.cardDraw[cardlist[indexOfList]]
                framesOfMatchedCards.append(cardView.frame)
                playingFieldView.bringSubviewToFront(cardView)
                cardBehavior.addCardBehavior(cardView)
            }
          //  var timer : Timer?
            _ = Timer.scheduledTimer(
                withTimeInterval: Constants.timeIntervel ,
                repeats: false)
            { timer in
                self.animator.removeAllBehaviors()
                self.changingSetOfCards(cardlists,framesOfMatchedCards: framesOfMatchedCards)
            }
        }
    }
    //    ///////////////////////////////----------------------cardSelection
    @IBAction func DealSetOfCards(_ sender: UIButton) {
        deck.isEnabled = false
        deck.backgroundColor =  #colorLiteral(red: 0.5128239913, green: 0.501409506, blue: 0.5141775063, alpha: 1)
        Deal3MoreCards()
       
        _ = Timer.scheduledTimer(
            withTimeInterval: Constants.timeIntervel * 3,
            repeats: false)
        {  timer in
            self.deck.isEnabled = true
            self.deck.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    ///////////////////////////////---------------------------Deal3MoreCards
    func Deal3MoreCards() {
        addNewCards(ofCount: 3 )
        drawCardsFromDeck(byCountOf: 3 )
    }
    //////////////////////////////----------------------------addNewCards
    func addNewCards(ofCount count: Int)
    {
        var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardRatio ) ,frame: playingFieldView.bounds)
        grid.cellCount = cardWithFaces + count
        for index in 0...cardWithFaces - 1
        {
            playingFieldView.addCardAsSubview(at: index,  grid[index]!)
        }
    }
    
    @IBOutlet weak var deck: UIButton!
    
    /////////////////////--------------------------------------cardFrame
    func defineCardFrame(_ frame: CGRect) {
        var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardRatio ) ,frame: frame)
        grid.cellCount = cardWithFaces
        
        for index in 0...cardWithFaces - 1
        {
            playingFieldView.addCardAsSubview(at: index, grid[index]!)
        }
    }
    //    ///////////////////////////////------btn---------------newGame
    @IBAction func newGame(_ sender: UIButton) {
        
        self.EnableButtons(enable: false)
        newGameStart.backgroundColor = #colorLiteral(red: 0.5128239913, green: 0.501409506, blue: 0.5141775063, alpha: 1)
        startNewGame()
    }
    func startNewGame()
    {
        self.EnableButtons(enable: false)
        cardlist.removeAll()
        gameOfSet = SetCardGame()
        cardWithFaces = 0
        cardsface = CardFaces()
        for subUIView in playingFieldView.subviews
        {
            subUIView.removeFromSuperview()
        }
        playingFieldView.cardDraw.removeAll()
        scoreLable.text = "Set:0"
        startingScreen()
    }
    ////===
    
    
    //////////////////----------------------------------------changeSubviewBounds
    func changeSubviewBounds( frame : CGRect)
    {
        if cardWithFaces > 0
        {
            defineCardFrame(frame)
        }
    }
    ////////////-------------------------------------------tapFunction
    @objc func tapFunction(_ sender: UITapGestureRecognizer){
        
        let loc = sender.location(in: sender.view)
        let firstHitView =  playingFieldView.cardDraw.first(where: {
            (loc.x > $0.frame.origin.x && loc.y > $0.frame.origin.y) &&
                (loc.x < ($0.frame.origin.x + $0.bounds.width)) &&
                (loc.y < ($0.frame.origin.y + $0.bounds.height)) }  )
        
        if let cardNumber = playingFieldView.cardDraw.firstIndex(of: firstHitView ?? SketchOfSymbols())
        {
            if cardlist.filter({$0 == cardNumber}).isEmpty
            {
                if cardlist.count < 3
                {
                    cardlist.append(cardNumber)
                    playingFieldView.cardSelection(click: true, on: cardNumber)
                }
                else
                {
                    checkSet()
                }
            }
            else
            {
                cardlist.remove(at: cardlist.firstIndex(of: cardNumber)!)
                playingFieldView.cardSelection(click: false, on: cardNumber)
            }
        }
    }
    
    //////////////////////////////////---------------------checkSet
    func checkSet()
    {
        for index in 0...2
        {
            let index = cardlist[index]
            gameOfSet.chooseCardSet(
                symbol: playingFieldView.cardDraw[index].symbol ,
                countShape: playingFieldView.cardDraw[index].countShape ,
                shade: playingFieldView.cardDraw[index].shade,
                color: playingFieldView.cardDraw[index].color  )
        }
        updateView(ifMatched : gameOfSet.CheckSetOfCards())
        cardlist.removeAll()
    }
    //////////--------------------------------------drawCardFaces
    func AttributingCardFaces (index : Int) {
        
        if(!cardsface.isArrayEmpty())
        {
            let attributes = cardsface.randomCardFace()
            playingFieldView.cardDraw.append(SketchOfSymbols())
            
            playingFieldView.cardDraw[index].setData(
                symbol: attributes.symbol,
                countShape:  attributes.countShape,
                shade:  attributes.shade,
                color:  attributes.color)
        }
    }
    ///////////////////----------------------buttonEnable
    func EnableButtons(enable:Bool){
        newGameStart.isEnabled = enable
        deck.isEnabled = enable
    }
    
}
struct Constants
{
    static let timeIntervel = 0.5
    static let cardRatio : CGFloat = 0.8
}
