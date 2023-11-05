//
//  Final Screen.swift
//  Brain Train
//
//  Created by Ogechi Nwankwo on 10/31/23.
//

import Foundation
import UIKit
import WebKit
import AVFoundation

class FinalScreen: UIViewController {
    
    var soundPlayer: AVAudioPlayer?
    @IBOutlet var webView: WKWebView!
    @IBOutlet var game1Points: UILabel!
    @IBOutlet var game2Points: UILabel!
    @IBOutlet var game3Points: UILabel!
    @IBOutlet var totalPoints: UILabel!

    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if let gifPath = Bundle.main.url(forResource: "confetti29", withExtension: "gif") {
                let request = URLRequest(url: gifPath)
                webView.load(request)
            }
        game1Points.text = "Game 1: " + String(FirstLevelGame.Const.points) + " Points"
        game2Points.text = "Game 2: " + String(SecondLevelGame.Const2.points2) + " Points"
        game3Points.text = "Game 3: " + String(ThirdLevelGame.Const3.points3) + " Points"
        totalPoints.text = "Total Points: " + String(FirstLevelGame.Const.points + SecondLevelGame.Const2.points2 + ThirdLevelGame.Const3.points3)
        
        playSound(named: "success")
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
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
}
