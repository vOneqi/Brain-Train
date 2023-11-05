//
//  ThirdLevelGame.swift
//  BrainGames
//
//  Created by Ogechi Nwankwo on 10/31/23.
//

import Foundation
import UIKit
import AVFoundation

class ThirdLevelGame: UIViewController {
    
    struct Const3{
        static var points3 = 0
    }

    var soundPlayer: AVAudioPlayer?

    private var gameOn3 = true
    var width: CGFloat = 0
    var height: CGFloat = 0
    var x: Int = 0
    var y: Int = 0
    
    @IBOutlet var pointsNum: UILabel!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet var greenCircle: UIImageView!
    @IBOutlet var redCircle: UIImageView!
    @IBOutlet var gameOverBox: UIImageView!
    @IBOutlet var gameOver: UILabel!
    @IBOutlet var nextLevel: UIButton!
    
    var timer = Timer()
    var repeatCount = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        weightedRandomHighlight()
        calculateDimensions()
        setCirclesCoords()
        if gameOn3{
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(repeatCode), userInfo: nil, repeats: true)
            gameOverBox.center.y = view.center.y
            gameOverBox.center.y -= view.bounds.height
            
            gameOver.center.y = view.center.y
            gameOver.center.y -= view.bounds.height
            
            nextLevel.center.y = view.center.y
            nextLevel.center.y -= view.bounds.height
        }
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @objc func repeatCode() {
            //Executed every 0.5 seconds
            gameWork()
            repeatCount += 1

            if !gameOn3 {
                timer.invalidate()
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    var timer2 = Timer()
    var secondsRemaining = 30

    func startCountdown() {
        // Start the timer with a 1-second interval
        timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    func stopCountdown() {
        timer2.invalidate()
    }
    
    @objc func updateCountdown() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            timerText.text = "Time: " + String(secondsRemaining)
        }
        else {
            stopCountdown()
            greenCircle.image = nil
            redCircle.image = nil
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
            gameOn3 = false
        }
    }
    
    func randomNumber(probabilities: [Double]) -> Int {
        //Sum of all probabilities (so don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = Double.random(in: 0.0 ..< sum)
        //Finds first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        //Point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
    }
    
    func weightedRandomHighlight() {
        if randomNumber(probabilities: [7.0, 3.0]) == 0 {
            greenCircle.image = UIImage(systemName: "circle.fill")
            redCircle.image = nil // Clears the red circle
        } else {
            greenCircle.image = nil // Clears the green circle
            redCircle.image = UIImage(systemName: "circle.fill")
        }
    }

    func calculateDimensions() {
        x = Int.random(in: 50..<350)
        y = Int.random(in: 128..<628)
    }
    
    func setCirclesCoords(){
        greenCircle.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
        calculateDimensions()
        redCircle.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    func gameWork(){
        weightedRandomHighlight()
        calculateDimensions()
        setCirclesCoords()
    }
    
    var t = 1
    private func handleCircleTap(_ circle: UIImageView) {
        if t==1 && gameOn3{
            startCountdown()
            t+=1
        }
    }
    
    @IBAction func tapGreenCircle(_ sender: UITapGestureRecognizer) {
        if greenCircle.image == UIImage(systemName: "circle.fill") && gameOn3 {
            handleCircleTap(greenCircle)
            
            Const3.points3 += 1
            pointsNum.text = "Points: " + String(Const3.points3)
            
            playSound(named: "correct")
        }
    }
    
    @IBAction func tapRedCircle(_ sender: UITapGestureRecognizer) {
        if redCircle.image == UIImage(systemName: "circle.fill") && gameOn3 {
            handleCircleTap(redCircle)
            Const3.points3 -= 1
            pointsNum.text = "Points: " + String(Const3.points3)
            
            playSound(named: "wrong")
        }
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
     Variable = Random pick one outlet from array
     Parameter function(variable outlet)
        Highlight picked outlet for 0.2 seconds
    @IBAction func user clicks image
        if Outlet highlighted{
            points += 1
            points label +1
        }
     */

}
