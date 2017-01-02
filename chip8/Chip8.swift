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
    ///
    /// This function gets a op and break it in 4 hexadecimal parts
    /// 0x1234 -> a=1,b=2,c=3,d=4
    
    public func op(op: UInt16){
        let d = op & 0xf
        let c = (op>>4) & 0xf
        let b = (op>>8) & 0xf
        let a = (op>>12) & 0xf
        
        switch (a,b,c,d) {
            /*
            0nnn - SYS addr
            Jump to a machine code routine at nnn.
            
            This instruction is only used on the old computers on which Chip-8 was originally implemented. It is ignored by modern interpreters.
            */
        case (0,_,_,_):
            print("nao implementado")
            
            /*
            00E0 - CLS
            Clear the display.
            */
        case (0,0,0xE,0):
            print("nao implementado")

            
            /*
            00EE - RET
            Return from a subroutine.
            
            The interpreter sets the program counter to the address at the top of the stack, then subtracts 1 from the stack pointer.
            */
        case (0,0,0xE,0xE):
            print("nao implementado")
            
            
            
            /*
            1nnn - JP addr
            Jump to location nnn.
            
            The interpreter sets the program counter to nnn.
            */
        case (1,_,_,_):
            print("nao implementado")
            
            
            
            /*
            2nnn - CALL addr
            Call subroutine at nnn.
            
            The interpreter increments the stack pointer, then puts the current PC on the top of the stack. The PC is then set to nnn.
            */
        case (2,_,_,_):
            print("nao implementado")
            
            
            
            /*
            3xkk - SE Vx, byte
            Skip next instruction if Vx = kk.
            
            The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
             */
        case (3,_,_,_):
            print("nao implementado")
            
            
            
            /*
            4xkk - SNE Vx, byte
            Skip next instruction if Vx != kk.
            
            The interpreter compares register Vx to kk, and if they are not equal, increments the program counter by 2.
            */
        case (3,_,_,_):
            print("nao implementado")
            
            
            
            /*
            5xy0 - SE Vx, Vy
            Skip next instruction if Vx = Vy.
            
            The interpreter compares register Vx to register Vy, and if they are equal, increments the program counter by 2.
            */
        case (5,_,_,0):
            print("nao implementado")
            
            
            
            /*
            6xkk - LD Vx, byte
            Set Vx = kk.
            
            The interpreter puts the value kk into register Vx.
            */
        case (6,_,_,_):
            print("nao implementado")
            
            
            
            /*
            7xkk - ADD Vx, byte
            Set Vx = Vx + kk.
            
            Adds the value kk to the value of register Vx, then stores the result in Vx.
        
             */
        case (7,_,_,_):
            print("nao implementado")
            
            
            
            /*
            8xy0 - LD Vx, Vy
            Set Vx = Vy.
            
            Stores the value of register Vy in register Vx.
            
            */
        case (8,_,_,0):
            print("nao implementado")
            
            
            
            /*
            8xy1 - OR Vx, Vy
            Set Vx = Vx OR Vy.
            
            Performs a bitwise OR on the values of Vx and Vy, then stores the result in Vx. A bitwise OR compares the corrseponding bits from two values, and if either bit is 1, then the same bit in the result is also 1. Otherwise, it is 0.
            
            */
        case (8,_,_,1):
            print("nao implementado")
            
            
            
            /*
            8xy2 - AND Vx, Vy
            Set Vx = Vx AND Vy.
            
            Performs a bitwise AND on the values of Vx and Vy, then stores the result in Vx. A bitwise AND compares the corrseponding bits from two values, and if both bits are 1, then the same bit in the result is also 1. Otherwise, it is 0.
            */
        case (8,_,_,2):
            print("nao implementado")
            
            
            
            /*
            8xy3 - XOR Vx, Vy
            Set Vx = Vx XOR Vy.
            
            Performs a bitwise exclusive OR on the values of Vx and Vy, then stores the result in Vx. An exclusive OR compares the corrseponding bits from two values, and if the bits are not both the same, then the corresponding bit in the result is set to 1. Otherwise, it is 0.
            */
        case (8,_,_,3):
            print("nao implementado")
            
            
            
            /*
            8xy4 - ADD Vx, Vy
            Set Vx = Vx + Vy, set VF = carry.
            
            The values of Vx and Vy are added together. If the result is greater than 8 bits (i.e., > 255,) VF is set to 1, otherwise 0. Only the lowest 8 bits of the result are kept, and stored in Vx.
            */
        case (8,_,_,4):
            print("nao implementado")
        
            
            
            /*
            8xy5 - SUB Vx, Vy
            Set Vx = Vx - Vy, set VF = NOT borrow.
            
            If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
            */
        case (8,_,_,5):
            print("nao implementado")
            
            
            
            /*
            8xy6 - SHR Vx {, Vy}
        Set Vx = Vx SHR 1.
        
        If the least-significant bit of Vx is 1, then VF is set to 1, otherwise 0. Then Vx is divided by 2.
            */
        case (8,_,_,6):
            print("nao implementado")
            
            /*
             8xy7 - SUBN Vx, Vy
        Set Vx = Vy - Vx, set VF = NOT borrow.
        
        If Vy > Vx, then VF is set to 1, otherwise 0. Then Vx is subtracted from Vy, and the results stored in Vx.
        */
        case (8,_,_,7):
            print("nao implementado")
            
            
            
            /*
        8xyE - SHL Vx {, Vy}
        Set Vx = Vx SHL 1.
        
        If the most-significant bit of Vx is 1, then VF is set to 1, otherwise to 0. Then Vx is multiplied by 2.
        */
        case (8,_,_,0xE):
            print("nao implementado")
            
            
            
            /*
        9xy0 - SNE Vx, Vy
        Skip next instruction if Vx != Vy.
        
        The values of Vx and Vy are compared, and if they are not equal, the program counter is increased by 2.
        */
        case (9,_,_,0):
            print("nao implementado")
            
            
            
            /*
        Annn - LD I, addr
        Set I = nnn.
        
        The value of register I is set to nnn.
        */
        case (0xA,_,_,_):
            print("nao implementado")

            
            
        /*
        Bnnn - JP V0, addr
        Jump to location nnn + V0.
        
        The program counter is set to nnn plus the value of V0.
        */
        case (0xB,_,_,_):
            print("nao implementado")
            
            
            
            /*
        Cxkk - RND Vx, byte
        Set Vx = random byte AND kk.
        
        The interpreter generates a random number from 0 to 255, which is then ANDed with the value kk. The results are stored in Vx. See instruction 8xy2 for more information on AND.
        */
        case (0xC,_,_,_):
            print("nao implementado")
            
            
            
            
            /*
        Dxyn - DRW Vx, Vy, nibble
        Display n-byte sprite starting at memory location I at (Vx, Vy), set VF = collision.
        
        The interpreter reads n bytes from memory, starting at the address stored in I. These bytes are then displayed as sprites on screen at coordinates (Vx, Vy). Sprites are XORed onto the existing screen. If this causes any pixels to be erased, VF is set to 1, otherwise it is set to 0. If the sprite is positioned so part of it is outside the coordinates of the display, it wraps around to the opposite side of the screen. See instruction 8xy3 for more information on XOR, and section 2.4, Display, for more information on the Chip-8 screen and sprites.
             
            */
        case (0xD,_,_,_):
            print("nao implementado")
            
            
            
            /*
        Ex9E - SKP Vx
        Skip next instruction if key with the value of Vx is pressed.
        
        Checks the keyboard, and if the key corresponding to the value of Vx is currently in the down position, PC is increased by 2.
        */
        case (0xE,_,9,0xE):
            print("nao implementado")
            
            
            
            /*
        ExA1 - SKNP Vx
        Skip next instruction if key with the value of Vx is not pressed.
        
        Checks the keyboard, and if the key corresponding to the value of Vx is currently in the up position, PC is increased by 2.
        */
        case (0xE,_,0xA,1):
            print("nao implementado")
            
           
            
            /*
        Fx07 - LD Vx, DT
        Set Vx = delay timer value.
        
        The value of DT is placed into Vx.
        */
        case (0xF,_,0,7):
            print("nao implementado")
            
            
            
            /*
        Fx0A - LD Vx, K
        Wait for a key press, store the value of the key in Vx.
        
        All execution stops until a key is pressed, then the value of that key is stored in Vx.
        */
        case (0xF,_,0,0xA):
            print("nao implementado")
            
        
            
            /*
        Fx15 - LD DT, Vx
        Set delay timer = Vx.
        
        DT is set equal to the value of Vx.
        */
        case (0xF,_,1,5):
            print("nao implementado")
            
            
            
            /*
        Fx18 - LD ST, Vx
        Set sound timer = Vx.
        
        ST is set equal to the value of Vx.
        */
        case (0xF,_,1,8):
            print("nao implementado")
            
            
            
            /*
        Fx1E - ADD I, Vx
        Set I = I + Vx.
        
        The values of I and Vx are added, and the results are stored in I.
        */
        case (0xF,_,1,0xE):
            print("nao implementado")
            
            
            
            /*
        Fx29 - LD F, Vx
        Set I = location of sprite for digit Vx.
        
        The value of I is set to the location for the hexadecimal sprite corresponding to the value of Vx. See section 2.4, Display, for more information on the Chip-8 hexadecimal font.
        */
        case (0xF,_,2,9):
            print("nao implementado")
            
            
            
            /*
        Fx33 - LD B, Vx
        Store BCD representation of Vx in memory locations I, I+1, and I+2.
        
        The interpreter takes the decimal value of Vx, and places the hundreds digit in memory at location in I, the tens digit at location I+1, and the ones digit at location I+2.
        */
        case (0xF,_,3,3):
            print("nao implementado")
            
            
            
            /*
        Fx55 - LD [I], Vx
        Store registers V0 through Vx in memory starting at location I.
        
        The interpreter copies the values of registers V0 through Vx into memory, starting at the address in I.
        */
        case (0xF,_,5,5):
            print("nao implementado")
            
            
            
            /*
        Fx65 - LD Vx, [I]
        Read registers V0 through Vx from memory starting at location I.
        
        The interpreter reads values from memory starting at location I into registers V0 through Vx.*/
        case (0xF,_,6,5):
            print("nao implementado")
        
        default:
            print("OPS, UNKNOW INSTRUCTION")
        }
        
    }
    
    
    
    
    
    
    

}
