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
    private var chip : Chip8!
    
    
    
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
            
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func keyUp(with event: NSEvent) {
        <#code#>
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
      
        
    }
}
