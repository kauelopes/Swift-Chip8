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
        chip = Chip8(screen: screen)
        DispatchQueue.global().async {
            // Bounce back to the main thread to update the UI
            self.chip.run()
            DispatchQueue.main.async {
            }
        }
 
        
    }
    
    
    

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 29:
            screen.clear()
            chip.pressButton(key: 0)
        case 18:
            chip.pressButton(key: 1)
        case 19:
            chip.pressButton(key: 2)
        case 20:
            chip.pressButton(key: 3)
        case 21:
            chip.pressButton(key: 4)
        case 22:
            chip.pressButton(key: 5)
        case 23:
            chip.pressButton(key: 6)
        case 24:
            chip.pressButton(key: 7)
        case 25:
            chip.pressButton(key: 8)
        case 26:
            chip.pressButton(key: 9)
        case 0:
            chip.pressButton(key: 10)
        case 1:
            chip.pressButton(key: 11)
        case 2:
            chip.pressButton(key: 12)
        case 3:
            chip.pressButton(key: 13)
        case 4:
            chip.pressButton(key: 14)
        case 5:
            chip.pressButton(key: 15)
        default:
            print("Pressed unknown key \(event.keyCode)")
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 18 + 0:
            chip.releaseButton(key: 0)
        case 18 + 1:
            chip.releaseButton(key: 1)
        case 18 + 2:
            chip.releaseButton(key: 2)
        case 18 + 3:
            chip.releaseButton(key: 3)
        case 18 + 4:
            chip.releaseButton(key: 4)
        case 18 + 5:
            chip.releaseButton(key: 5)
        case 18 + 6:
            chip.releaseButton(key: 6)
        case 18 + 7:
            chip.releaseButton(key: 7)
        case 18 + 8:
            chip.releaseButton(key: 8)
        case 18 + 9:
            chip.releaseButton(key: 9)
        case 0:
            chip.releaseButton(key: 10)
        case 1:
            chip.releaseButton(key: 11)
        case 2:
            chip.releaseButton(key: 12)
        case 3:
            chip.releaseButton(key: 13)
        case 4:
            chip.releaseButton(key: 14)
        case 5:
            chip.releaseButton(key: 15)
        default:
            print("Pressed unknown key")
        }
    }
    

    
    override func update(_ currentTime: TimeInterval) {

      
        
    }
}
