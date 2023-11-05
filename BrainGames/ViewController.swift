//
//  ViewController.swift
//  BrainGames
//
//  Created by Ogechi Nwankwo on 10/28/23.
//

import UIKit
import AVFoundation
import Firebase

class ViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var brainImage: UIImageView!
    @IBOutlet var volumeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
        
    @IBAction func startButtonTapped() {
        brainImage.center.x = view.center.x-50 //Places in center x of the view
        //animate from left to right
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.brainImage.center.x -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.titleLabel.center.x -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func volumeTapped(){
        if AudioManager.shared.audioPlayer?.isPlaying == true {
                AudioManager.shared.stopBackgroundMusic()
                volumeButton.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
            } else {
                AudioManager.shared.playBackgroundMusic()
                volumeButton.setImage(UIImage(systemName: "speaker.3.fill"), for: .normal)
            }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        brainImage.center.x = view.center.x-50
        brainImage.center.x -= view.bounds.width
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.brainImage.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        titleLabel.center.x = view.center.x //Places in center x of the view
        titleLabel.center.x -= view.bounds.width //Place on left of the view with the width = bounds' width of view
        //animate from left to right
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.titleLabel.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            // Navigate back to the login screen
            if let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() {
                UIApplication.shared.keyWindow?.rootViewController = loginVC
            }
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
}

