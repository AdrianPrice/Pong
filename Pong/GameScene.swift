//
//  GameScene.swift
//  Pong
//
//  Created by Adrian Price on 22/7/20.
//  Copyright © 2020 Adrian Price. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Initialise both paddles and the ball
    var ball = SKSpriteNode()
    var topPaddle = SKSpriteNode()
    var bottomPaddle = SKSpriteNode()
    
    var topLabel = SKLabelNode()
    var bottomLabel = SKLabelNode()
    
    //Initialise the score
    var score = [Int]()
    var topScore = SKLabelNode()
    var bottomScore = SKLabelNode()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        //Links the GameScene object with my variable
        topScore = self.childNode(withName: "topScore") as! SKLabelNode
        bottomScore = self.childNode(withName: "bottomScore") as! SKLabelNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        topPaddle = self.childNode(withName: "topPaddle") as! SKSpriteNode
        bottomPaddle = self.childNode(withName: "bottomPaddle") as! SKSpriteNode
        
        topLabel = self.childNode(withName: "topLabel") as! SKLabelNode
        bottomLabel = self.childNode(withName: "bottomLabel") as! SKLabelNode
        
        topLabel.isHidden = true
        bottomLabel.isHidden = true
        
        //Sets paddle position and sizes (dependant on screen size)
        topPaddle.position.y = (self.frame.height / 2) - 100
        topPaddle.size = CGSize(width: self.frame.height / 5, height: self.frame.height / 30)
        
        bottomPaddle.position.y = (-1 * self.frame.height / 2) + 100
        bottomPaddle.size = CGSize(width: self.frame.height / 5, height: self.frame.height / 30)
        
        
        //Gives the border of the screen a physics body so that the ball bounces
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        //Starts the game
        startGame()
    }
    
    func startGame() {
        //Resets score to 0
        score = [0, 0]
        
        bottomScore.text = "\(score[0])"
        topScore.text = "\(score[1])"
        
        //Starts the ball moving
        moveBall(movingUp: false)
        
    }
    
    func moveBall(movingUp: Bool) {
        let randomInt = Int.random(in: 10...40)
        let randomInt2 = Int.random(in: 1...2)
        
        var finalInt: Int
        
        if randomInt2 == 2 {
            finalInt = -randomInt
        } else {
            finalInt = randomInt
        }
        
        if movingUp {
            ball.physicsBody?.applyImpulse(CGVector(dx: finalInt, dy: 20))
        } else {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -20))
        }
    }
    
    func addScore (playerWhoWon: SKSpriteNode) {
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if playerWhoWon == bottomPaddle {
            score[0] += 1
            if !isGameOver() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.moveBall(movingUp: false)
                }
            }
            
            
        } else {
            score[1] += 1
            if !isGameOver() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.moveBall(movingUp: true)
                }
            }
        }
        
        bottomScore.text = "\(score[0])"
        topScore.text = "\(score[1])"
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var ballOb = contact.bodyB.node
        var ballPos = ballOb?.position.x
        
        if contact.bodyA.node?.name == "topPaddle" {
            var paddle = contact.bodyA.node
            
            
            var paddleWidth = self.frame.width / 5
            
            if let xPos = paddle?.position.x {
                var leftmostX = xPos - (paddleWidth / 2)
                
                if let ballPos =  ballOb?.position.x {
                    if !ballPos.isLess(than: xPos + (3 * paddleWidth / 5)) {
                        ballOb?.physicsBody?.applyImpulse(CGVector(dx: 8, dy: 0))
                    } else if !ballPos.isLess(than: xPos + (paddleWidth / 10)){
                        ballOb?.physicsBody?.applyImpulse(CGVector(dx: 4, dy: 0))
                    } else if ballPos.isLess(than: xPos - (3 * paddleWidth / 5)) {
                        ballOb?.physicsBody?.applyImpulse(CGVector(dx: -8, dy: 0))
                    } else {
                        ballOb?.physicsBody?.applyImpulse(CGVector(dx: -4, dy: 0))
                    }
                }
            }
            
            
        } else if contact.bodyA.node?.name == "bottomPaddle" {
            var paddle = contact.bodyA.node
            
            
            var paddleWidth = self.frame.width / 5
            
            if let xPos = paddle?.position.x {
                var leftmostX = xPos - (paddleWidth / 2)
                
                if let ballPos =  ballOb?.position.x {
                    if !ballPos.isLess(than: xPos + (3 * paddleWidth / 5)) {
                        ballOb?.physicsBody?.applyImpulse(CGVector(dx: 8, dy: 0))
                    } else if !ballPos.isLess(than: xPos + (paddleWidth / 10)){
                        ballOb?.physicsBody?.applyImpulse(CGVector(dx: 4, dy: 0))
                    } else if ballPos.isLess(than: xPos - (3 * paddleWidth / 5)) {
                        ballOb?.physicsBody?.applyImpulse(CGVector(dx: -8, dy: 0))
                    } else if ballPos.isLess(than: xPos - (paddleWidth / 10)){
                        ballOb?.physicsBody?.applyImpulse(CGVector(dx: -4, dy: 0))
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameType == .TwoPlayer {
                if location.y > 0 {
                    topPaddle.run(SKAction.moveTo(x: location.x, duration: 0.05))
                }
                
                if location.y < 0 {
                    bottomPaddle.run(SKAction.moveTo(x: location.x, duration: 0.05))
                }
            } else {
                bottomPaddle.run(SKAction.moveTo(x: location.x, duration: 0.05))
            }
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameType == .TwoPlayer {
                if location.y > 0 {
                    topPaddle.run(SKAction.moveTo(x: location.x, duration: 0.05))
                }
                
                if location.y < 0 {
                    bottomPaddle.run(SKAction.moveTo(x: location.x, duration: 0.05))
                }
            } else {
                bottomPaddle.run(SKAction.moveTo(x: location.x, duration: 0.05))
            }
            
            
        }
    }
    
    func isGameOver() -> Bool{
        if score[0] >= 10 || score[1] >= 10 {
            return true
        } else {
            return false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if !isGameOver() {
            switch currentGameType {
            case .Easy:
                topPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.4))
                
                break
            case .Medium:
                topPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
                
                break
            case .Hard:
                topPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.08))
                
                break
            case .TwoPlayer:
                
                break
            }
            
            if ball.position.y <= bottomPaddle.position.y - 70 {
                addScore(playerWhoWon: topPaddle)
            } else if ball.position.y >= topPaddle.position.y + 70 {
                addScore(playerWhoWon: bottomPaddle)
            }
        } else {
            if score[0] >= 10 {
                bottomLabel.text = "YOU WIN!!!"
                topLabel.text = "YOU LOSE!!!!"
            } else {
                topLabel.text = "YOU WIN!!!"
                bottomLabel.text = "YOU LOSE!!!!"
            }
            
            print(self.frame.width)
            if self.frame.width <= 414 {
                topLabel.fontSize = 45
                bottomLabel.fontSize = 45
            }
            
            topLabel.position.y = (self.frame.height / 2) - 200
            bottomLabel.position.y = (-self.frame.height / 2) + 200
            
            topLabel.isHidden = false
            bottomLabel.isHidden = false
        }
    }
}
