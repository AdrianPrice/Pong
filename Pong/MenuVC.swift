//
//  MenuVC.swift
//  Pong
//
//  Created by Adrian Price on 22/7/20.
//  Copyright © 2020 Adrian Price. All rights reserved.
//

import Foundation
import UIKit

enum gameType {
    case Easy
    case Medium
    case Hard
    case TwoPlayer
}


class MenuVC: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var AILabel: UILabel!
    @IBOutlet weak var easyLabel: UIButton!
    @IBOutlet weak var mediumLabel: UIButton!
    @IBOutlet weak var hardLabel: UIButton!
    @IBOutlet weak var multiplayerLabel: UILabel!
    @IBOutlet weak var twoPlayerLabel: UIButton!
    
    
    override func viewDidLoad() {
        titleLabel.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 5)
        AILabel.center = CGPoint(x: view.frame.width / 2, y:  33 * view.frame.height / 100)
        easyLabel.center = CGPoint(x: view.frame.width / 2, y: 39 * view.frame.height / 100)
        mediumLabel.center = CGPoint(x: view.frame.width / 2, y: 4 * view.frame.height / 9)
        hardLabel.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        multiplayerLabel.center = CGPoint(x: view.frame.width / 2, y: 65 * view.frame.height / 100)
        twoPlayerLabel.center = CGPoint(x: view.frame.width / 2, y: 70 * view.frame.height / 100)
    }
    
    @IBAction func playEasy(_ sender: Any) {
        moveToGame(game: .Easy)    }
    
    @IBAction func playMedium(_ sender: Any) {
        moveToGame(game: .Medium)
    }
    @IBAction func playHard(_ sender: Any) {
        moveToGame(game: .Hard)
    }
    @IBAction func playTwoPlayer(_ sender: Any) {
        moveToGame(game: .TwoPlayer)
    }
    func moveToGame(game : gameType) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
        
        currentGameType = game
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}
