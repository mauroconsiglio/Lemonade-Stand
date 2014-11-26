//
//  ViewController.swift
//  Lemonade Stand
//
//  Created by Mauro Consiglio on 25/11/14.
//  Copyright (c) 2014 Mauro Consiglio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Inventory
    @IBOutlet weak var ownedMoneyLabel: UILabel!
    @IBOutlet weak var ownedLemonsLabel: UILabel!
    @IBOutlet weak var ownedIceCubesLabel: UILabel!
    
    // Purchase
    @IBOutlet weak var purchasedLemonLabel: UILabel!
    @IBOutlet weak var purchasedIceCubesLabel: UILabel!
    
    // Mix
    @IBOutlet weak var mixedLemonsLabel: UILabel!
    @IBOutlet weak var mixedIceCubesLabel: UILabel!
    
    // properties
    var myInventory = Inventory()
    var cost = Cost()
    
    var lemonsToPurchase = 0
    var iceCubesToPurchase = 0
    var lemonsToMix = 0
    var iceCubesToMix = 0
    
    // added weather
    var weatherArray:[[Int]] = [[-10, -9, -5, -7], [5, 8, 10, 9], [22, 25, 27, 23]]
    var weatherToday:[Int] = [0, 0, 0, 0]
    
    @IBOutlet weak var weatherImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myInventory.money = 10
        myInventory.lemons = 1
        myInventory.iceCubes = 1
        
        updateMainView()
        simulateWeatherToday()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // IBActions
    
    @IBAction func purchaseLemonButtonPressed(sender: UIButton) {
        
        if myInventory.money >= cost.lemonPrice {
            lemonsToPurchase += 1
            myInventory.lemons += 1
            myInventory.money -= cost.lemonPrice
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough money")
        }
    }
    
    @IBAction func unpurchaseLemonButtonPressed(sender: UIButton) {
        
        if lemonsToPurchase > 0 {
            lemonsToPurchase -= 1
            myInventory.lemons -= 1
            myInventory.money += cost.lemonPrice
            updateMainView()
        }
        else {
            showAlertWithText(header: "Error", message: "You don't have lemons to return")
        }
    }
    
    @IBAction func purchaseIceCubeButtonPressed(sender: UIButton) {
        
        if myInventory.money >= cost.iceCubePrice {
            iceCubesToPurchase += 1
            myInventory.iceCubes += 1
            myInventory.money -= cost.iceCubePrice
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough money")
        }
    }
    
    @IBAction func unpurchaseIceCubeButtonPressed(sender: UIButton) {
        
        if iceCubesToPurchase > 0 {
            iceCubesToPurchase -= 1
            myInventory.iceCubes -= 1
            myInventory.money += cost.iceCubePrice
            updateMainView()
        }
        else {
            showAlertWithText(header: "Error", message: "You don't have ice cubes to return")
        }
    }
    
    @IBAction func mixLemonButtonPressed(sender: UIButton) {
        
        if myInventory.lemons > 0 {
            lemonsToPurchase = 0
            lemonsToMix += 1
            myInventory.lemons -= 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough lemons in your inventory")
        }
    }
    
    @IBAction func unmixLemonButtonPressed(sender: UIButton) {
        
        if lemonsToMix > 0 {
            lemonsToMix -= 1
            myInventory.lemons += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "Still no lemons in your mix!")
        }
    }
    
    @IBAction func mixIceCubeButtonPressed(sender: UIButton) {
        
        if myInventory.iceCubes > 0 {
            iceCubesToPurchase = 0
            iceCubesToMix += 1
            myInventory.iceCubes -= 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough ice cubes in your inventory")
        }
    }
    
    @IBAction func unmixIceCubeButtonPressed(sender: UIButton) {
        
        if iceCubesToMix > 0 {
            iceCubesToMix -= 1
            myInventory.iceCubes += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "Still no ice cubes in your mix!")
        }
    }
    
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
        let average = findAverage(weatherToday)
        let customers = Int(arc4random_uniform(UInt32(abs(average))))
        println("You have \(customers) customers today")
        
        if lemonsToMix == 0 || iceCubesToMix == 0 {
            showAlertWithText(message: "You have to add at least 1 lemon and 1 ice cube first")
        }
        else {
            let lemonadeRatio = Double(lemonsToMix) / Double(iceCubesToMix)
            println("Lemonade ratio is \(lemonadeRatio)")
            
            for x in 1...customers {
                let preference = Double(arc4random_uniform(UInt32(101))) / 100
                
                if preference < 0.4 && lemonadeRatio > 1 {
                    myInventory.money += 1
                    println("The preference value is \(preference). Your customer likes acidic lemonade. Paid!")
                }
                else if preference > 0.6 && lemonadeRatio < 1 {
                    myInventory.money += 1
                    println("The preference value is \(preference). Your customer likes diluted lemonade. Paid!")
                }
                else if preference >= 0.4 && preference <= 0.6 && lemonadeRatio == 1 {
                    myInventory.money += 1
                    println("The preference value is \(preference). Your customer likes well balanced lemonade. Paid!")
                }
                else {
                    println("No match, no revenue")
                }
            }
            
            lemonsToPurchase = 0
            iceCubesToPurchase = 0
            lemonsToMix = 0
            iceCubesToMix = 0
            
            simulateWeatherToday()
            updateMainView()
            weatherImageView.hidden = false
        }
    }
    
    func updateMainView() {
        
        ownedMoneyLabel.text = "$\(myInventory.money)"
        ownedLemonsLabel.text = "\(myInventory.lemons)"
        ownedIceCubesLabel.text = "\(myInventory.iceCubes)"
        
        purchasedLemonLabel.text = "\(lemonsToPurchase)"
        purchasedIceCubesLabel.text = "\(iceCubesToPurchase)"
        
        mixedLemonsLabel.text = "\(lemonsToMix)"
        mixedIceCubesLabel.text = "\(iceCubesToMix)"
    }
    
    func showAlertWithText(header: String = "Warning", message: String) {
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func simulateWeatherToday() {
        
        let index = Int(arc4random_uniform(UInt32(weatherArray.count)))
        weatherToday = weatherArray[index]
        
        switch index {
            case 0: weatherImageView.image = UIImage(named: "Cold")
            case 1: weatherImageView.image = UIImage(named: "Mild")
            case 2: weatherImageView.image = UIImage(named: "Warm")
            default: weatherImageView.image = UIImage(named: "Warm")
        }
    }
    
    func findAverage (data:[Int]) -> Int {
        
        var sum = 0
        for x in data {
            sum += x
        }
        var average = Double(sum) / Double(data.count)
        var rounded:Int = Int(ceil(average))
        
        return rounded
    }
}

