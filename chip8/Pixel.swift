//
//  Pixel.swift
//  chip8
//
//  Created by Kaue Lopes de Moraes on 03/01/17.
//  Copyright © 2017 kauelm. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Pixel: SKShapeNode {
    private var color: SKColor = SKColor.black
    
    public func getColor() -> SKColor{
        return color
    }
    
    
    public func setColor(color: SKColor){
        self.color = color
        self.lineWidth = 0
        self.fillColor = color
        self.strokeColor = color
    }
    

}
