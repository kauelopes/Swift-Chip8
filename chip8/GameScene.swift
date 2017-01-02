//
//  GameScene.swift
//  chip8
//
//  Created by Kaue Lopes de Moraes on 30/12/16.
//  Copyright © 2016 kauelm. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var screen : Screen!
    
    
    override func didMove(to view: SKView) {
        screen = Screen(gameScene: self)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x12:
            print("APERTOU 1")
        default:
            let a = Int(arc4random_uniform(30))
            let b = Int(arc4random_uniform(30))
            
            screen.paintPixel(x: a, y: b, color: SKColor.white)
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
      
        
    }
}
