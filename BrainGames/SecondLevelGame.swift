//
//  SecondLevelGame.swift
//  BrainGames
//
//  Created by Ogechi Nwankwo on 10/29/23.
//

import Foundation
import UIKit
import AVFoundation

class SecondLevelGame: UIViewController, UITextFieldDelegate{
    
    var soundPlayer: AVAudioPlayer?
    @IBOutlet var pointsNum: UILabel!
    @IBOutlet var colorText: UILabel!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet var userInputBox: UITextField!
    @IBOutlet var gameOverBox: UIImageView!
    @IBOutlet var gameOver: UILabel!
    @IBOutlet var nextLevel: UIButton!
    
    struct Const2{
        static var points2 = 0
    }

    private var gameOn2 = true
    
    override func viewDidLoad(){
        super.viewDidLoad()
        userInputBox.delegate = self
        oneTextColor()
        oneFontColor()
        if gameOn2{
            gameOverBox.center.y = view.center.y
            gameOverBox.center.y -= view.bounds.height
            
            gameOver.center.y = view.center.y
            gameOver.center.y -= view.bounds.height
            
            nextLevel.center.y = view.center.y
            nextLevel.center.y -= view.bounds.height
        }
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    var timer = Timer()
    var secondsRemaining = 30

    func startCountdown() {
        // Start the timer with a 1-second interval
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    func stopCountdown() {
        timer.invalidate()
        view.endEditing(true)
    }
    
    @objc func updateCountdown() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            timerText.text = "Time: " + String(secondsRemaining)
        }
        else {
            stopCountdown()
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                self.gameOverBox.center.y += (self.view.bounds.width)*2.1
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                self.gameOver.center.y += (self.view.bounds.width)*1.9
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                self.nextLevel.center.y += (self.view.bounds.width)*2.2
                self.view.layoutIfNeeded()
            }, completion: nil)
            gameOn2 = false
        }
    }
    
    var colorsListText: [String] = ["red", "orange", "yellow", "green", "blue", "purple", "black", "brown"]
    
    var textColor = ""
    var fontColor = ""
    
    func oneTextColor() {
        textColor = colorsListText.randomElement() ?? "red"
        colorText.text = textColor.capitalized
    }
    
    func oneFontColor() {
        let randomFontColor: String = colorsListText.randomElement() ?? "red"
        if let color = colorFromString(randomFontColor) {
            colorText.textColor = color
            fontColor = randomFontColor
        }
    }

    func colorFromString(_ colorName: String) -> UIColor? {
        switch colorName {
            case "red":
                return UIColor.red
            case "orange":
                return UIColor.orange
            case "yellow":
                return UIColor.yellow
            case "green":
                return UIColor.green
            case "blue":
                return UIColor.blue
            case "purple":
                return UIColor.purple
            case "black":
                return UIColor.black
            case "brown":
                return UIColor.brown
            default:
                return nil
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Varify when "Enter" key is pressed here
        enterInput()
        return true
    }

    var t = 1
    func enterInput(){
        if t == 1 && gameOn2{
            startCountdown()
        }
        t+=1
        if userInputBox.text == fontColor || userInputBox.text?.capitalized == fontColor.capitalized{
            Const2.points2 += 1
            pointsNum.text = "Points: " + String(Const2.points2)
            playSound(named: "correct")
        }
        else{
            Const2.points2 -= 1
            pointsNum.text = "Points: " + String(Const2.points2)
            playSound(named: "wrong")
        }
        userInputBox.text = ""
        oneTextColor()
        oneFontColor()
    }
    
    func playSound(named soundName: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: "mp3") {
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                soundPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    

    /*
     30 second timer | DONE
     Array of colors | DONE
     Variable = random color from array == (uppercase version) | DONE
        Variable = text of label
     Another variable2 = random color from array == (lowercase version) | DONE
        Variable2 = color of label
     User inputs text within time limit
        startCountdown()
        if User input == variable2
            points += 1
            points label +1
        else
            points -= 1
            points label -1
     */
    
}
