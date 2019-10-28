//
//  CardBehavior.swift
//  Lecture 1 - Concentration
//
//  Created by Other develoeprs on 3/11/19.
//  Copyright © 2019 Michel Deiman. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    var itemBehavior : UIDynamicItemBehavior =
    {let this = UIDynamicItemBehavior()
        this.allowsRotation = true
        this.elasticity = 1.0
        this.resistance = 0
        return this
        }()
    var  collisionBehavior : UICollisionBehavior  =
    {
        let this = UICollisionBehavior()
        this.translatesReferenceBoundsIntoBoundary = true
        return this
    }     ()
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
        
    }
    func push(_ item: UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat(Int.random(in: 1...360))
        push.magnitude = 20.0
        
        
        push.action = { [unowned push, weak self]  in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    func addCardBehavior(_ item: UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
   
//    convenience init(by animator:UIDynamicAnimator) {
//        self.init()
//        animator.addBehavior(self)
//    }


}
