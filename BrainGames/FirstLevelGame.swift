//
//  FirstLevelGame.swift
//  BrainGames
//
//  Created by Ogechi Nwankwo on 10/29/23.
//

import Foundation
import UIKit
import AVFoundation

class FirstLevelGame: UIViewController {
    
    var soundPlayer: AVAudioPlayer?
    @IBOutlet var redCircle: UIImageView!
    @IBOutlet var yellowCircle: UIImageView!
    @IBOutlet var greenCircle: UIImageView!
    @IBOutlet var blueCircle: UIImageView!
    @IBOutlet var pointsNum: UILabel!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var gameOverBox: UIImageView!
    @IBOutlet var gameOver: UILabel!
    @IBOutlet var nextLevel: UIButton!
    
    private var switcher = true
    private var gameCircle = ""
    private var userPattern: [String] = []
    private var gamePattern: [String] = []
    private var gameOn = true
    private var patternNumb = 1
    struct Const{
        static var points = 0
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gameOn{
            gameOverBox.center.y = view.center.y
            gameOverBox.center.y -= view.bounds.height
            
            gameOver.center.y = view.center.y
            gameOver.center.y -= view.bounds.height
            
            nextLevel.center.y = view.center.y
            nextLevel.center.y -= view.bounds.height
        }
        self.navigationItem.setHidesBackButton(true, animated: false)
        if gameOn {
                usleep(750000)
                gameWork()
            }
        else{
            submitButton.isEnabled = false
            resetButton.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func handleCircleTap(_ circle: UIImageView) {
        circle.isHighlighted = switcher
        let seconds = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            circle.isHighlighted = !switcher
        }
    }
    
    @IBAction func tapRedCircle(_ sender: UITapGestureRecognizer) {
        handleCircleTap(redCircle)
        userPattern.append("red")
    }
    
    @IBAction func tapYellowCircle(_ sender: UITapGestureRecognizer) {
        handleCircleTap(yellowCircle)
        userPattern.append("yellow")
    }
    
    @IBAction func tapGreenCircle(_ sender: UITapGestureRecognizer) {
        handleCircleTap(greenCircle)
        userPattern.append("green")
    }
    
    @IBAction func tapBlueCircle(_ sender: UITapGestureRecognizer) {
        handleCircleTap(blueCircle)
        userPattern.append("blue")
    }
    
    func oneCirclePattern() {
        let number = Int.random(in: 0..<4)
        
        if number == 0 {
            redCircle.isHighlighted = true
            let seconds = 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                self.redCircle.isHighlighted = false
            }
            gameCircle = "red"
        } else if number == 1 {
            yellowCircle.isHighlighted = true
            let seconds = 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                self.yellowCircle.isHighlighted = false
            }
            gameCircle = "yellow"
        } else if number == 2 {
            greenCircle.isHighlighted = true
            let seconds = 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                self.greenCircle.isHighlighted = false
            }
            gameCircle = "green"
        } else if number == 3 {
            blueCircle.isHighlighted = true
            let seconds = 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                self.blueCircle.isHighlighted = false
            }
            gameCircle = "blue"
        }
    }
    
    func gameWork() {
        gameIteration(patternNumb)
    }
    
    func gameIteration(_ patternNumb: Int) {
        gamePattern = []   // Reset the game pattern
        userPattern = []   // Reset the user pattern
        
        var currentPattern = 0
        
        func displayNextPattern() {
            if currentPattern < patternNumb {
                // Disable user interaction during pattern display
                redCircle.isUserInteractionEnabled = false
                yellowCircle.isUserInteractionEnabled = false
                greenCircle.isUserInteractionEnabled = false
                blueCircle.isUserInteractionEnabled = false

                oneCirclePattern()
                gamePattern.append(gameCircle)

                // Wait for a moment before showing the next circle
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard self != nil else { return }

                    // Re-enable user interaction after the pattern is displayed
                    self?.redCircle.isUserInteractionEnabled = true
                    self?.yellowCircle.isUserInteractionEnabled = true
                    self?.greenCircle.isUserInteractionEnabled = true
                    self?.blueCircle.isUserInteractionEnabled = true

                    // Display the next pattern
                    displayNextPattern()
                }
                currentPattern += 1
            } else {
                // All patterns have been displayed; now enable the submit button
                self.submitButton.isEnabled = true
            }
        }


        // Start displaying patterns
        displayNextPattern()
    }
    
    func continueGame() {
        // Compare userPattern with gamePattern
        if userPattern == gamePattern {
            patternNumb = gamePattern.count + 1
            gameIteration(patternNumb)
            Const.points += 1
            pointsNum.text = "Points: " + String(Const.points)
            playSound(named: "correct")
        } else {
            gameOn = false
            submitButton.isEnabled = false
            resetButton.isEnabled = false
            playSound(named: "wrong")
            
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
            
        }
    }
    
    @IBAction func submitPattern() {
        //User's input pattern confirmation
        submitButton.isEnabled = false
        continueGame()
    }
    
    @IBAction func clearUserPattern() {
        userPattern = []
        // Display an alert
        showAlert(title: "Input has been cleared", message: "Hopefully you still remember the pattern")
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
     If more time things to add:
     1. Notif if leaving screen | DONE
     2. Stop user from making input while pattern showing | DONE
     3. Add best points system (with login)
     4. Add background music | DONE
     5. Logo | DONE
     6. Add constraints
     7. Lock orientation | DONE
     8. Confetti when done | DONE
     9. Add sound effects
     */
    
    
}
