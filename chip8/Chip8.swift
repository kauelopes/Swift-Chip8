//
//  Chip8.swift
//  chip8
//
//  Created by Kaue Lopes de Moraes on 02/01/17.
//  Copyright © 2017 kauelm. All rights reserved.
//



import Foundation


class Chip8{
    ///16 registers of Chip8
    ///named v1,v2,...vE,vF
    private var v = [UInt8!](repeating:nil, count: 16)
    
    ///Chip8 memory representation (4K bytes)
    ///
    ///reserved spaces
    /// + (0x000) - (0x200) CHIP-8 interpreter itself (Let it go!)
    /// + (0xEA0) - (0xEFF) Call stack
    /// + (0xEA0) - (0xEFF) Call stack
    /// + (0xF00) - (0xFFF) Display refresh
    private var memory = [UInt8!](repeating:nil, count:4096)
    
    ///Special register to store memory addresses
    private var iRegister : UInt16 = 0
    
    ///Program Counter
    private var pc : Int = 0x201
    
    private var stackSize : Int = 0
    
    enum Chip8Error: Error {
        case StackNilPop
        case StackOverFlow
        case ForbiddenAreaMemory
    }
    
    private func getMemory(address: UInt16) throws -> UInt8{
        if(address<0xE9f && address>0x201){
            return memory[Int(address)]
        }else{
            throw Chip8Error.ForbiddenAreaMemory
        }
    }
    
    private func setMemory(address: UInt16, value: UInt8) throws{
        if(address<0xE9f && address>0x201){
            memory[Int(address)] = value
        }else{
            throw Chip8Error.ForbiddenAreaMemory
        }
    }
    
    
    private func pullToStack(num: UInt8) throws -> Bool {
        if(stackSize<20){
            memory[0xEFF - stackSize] = num
            stackSize+=1
            return true
        }else{
            throw Chip8Error.StackOverFlow
        }
    }
    
    private func popFromStack() throws -> UInt8{
        if(stackSize>0){
            stackSize-=1
            return memory[0xEFF - stackSize]
        }else{
            throw Chip8Error.StackNilPop
        }
    }
    
    
    ///Mother funcion!
    ///
    /// Get the operation code and modify the memory and the registers
    public func op(op: UInt16){
        
    }
    
    
    
    
    
    
    

}
