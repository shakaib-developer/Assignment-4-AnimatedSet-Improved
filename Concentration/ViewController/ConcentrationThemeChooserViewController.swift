//
//  ConcentrationThemeChooserViewController.swift
//  Lecture 1 - Concentration
//
//  Created by Other develoeprs on 3/11/19.
//  Copyright © 2019 Michel Deiman. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    let themes =
        
    [ "Fruits": ["🍏","🍐","🍊","🍌","🍉","🍇","🍓","🍍","🥥","🍈","🍎","🍑"],
    "Weather": ["☀️","🌤","⛅️","☁️","🌦","⛈","🌩","❄️","💨","🌊","🌧","🌪"] ,
    "Pics":[" 🛤","🛣","🗾","🏞","🌅","🌄","🌁","🌆","🎆","🌉","🎑","🌌"]
    ]
    
    @IBAction func changeTheme(_ sender: Any) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   if segue.identifier == "Choose Theme"
   {
    if let themeName = (sender as? UIButton)?.currentTitle , let theme = themes[themeName]
   {
    if let cvc = segue.destination as? ConcentrationViewController
    {
        cvc.theme = theme
    }
    
    }
    
    }
    
    }
    
}
