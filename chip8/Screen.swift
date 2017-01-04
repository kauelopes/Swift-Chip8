//
//  Screen.swift
//  chip8
//
//  Created by Kaue Lopes de Moraes on 30/12/16.
//  Copyright © 2016 kauelm. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Screen{
    private var pixels: [[Pixel]] = []
    
    
    init(gameScene: GameScene) {
        for i in 0..<64{
            var tmp : [Pixel] = []
            for j in 0..<32{
                let tmpNode = Pixel(rect: CGRect(x: 8*i, y: 8*j, width: 8, height: 8))
                tmpNode.setColor(color: SKColor.black)
                gameScene.addChild(tmpNode)
                tmp.append(tmpNode)
            }
            pixels.append(tmp)
        }
    }
    
    private func paintPixel(x: Int, y: Int,color: SKColor){
        if(x>63 || x<0 || y>31 || y<0){
            print("TENTOU MUDAR PIXEL INVALIDO")
        }
        pixels[x][y].setColor(color: color)
    }
    
    func drawPixel(x:Int, y: Int) -> Bool{
        if(x>63 || x<0 || y>31 || y<0){
            print("TENTOU MUDAR PIXEL INVALIDO")
            return true
        }
        if(pixels[x][y].getColor() == SKColor.white){
            print("BATEU")
            paintPixel(x: x, y: y, color: SKColor.black)
            return false
        }else{
            paintPixel(x: x, y: y, color: SKColor.white)
            return true
        }
        
        
    }
    
    func clear(){
        for a in 0...63 {
            for b in 0...31{
                paintPixel(x: a, y: b, color: SKColor.black)
            }
        }
        
    }
    
    

}
