//
//  Chip8.swift
//  chip8
//
//  Created by Kaue Lopes de Moraes on 02/01/17.
//  Copyright © 2017 kauelm. All rights reserved.
//



import Foundation


class Chip8{
    
    //# MARK: - Variables
    
    ///16 registers of Chip8
    ///named v1,v2,...vE,vF
    private var v = [UInt8!](repeating:nil, count: 16)
    
    ///Chip8 memory representation (4K bytes)
    ///
    ///reserved spaces
    /// + (0x000) - (0x1BF) CHIP-8 interpreter reserved space
    /// + (0x1C0) - (0x1FF) Call Stack 64 bytes (16 levels)
    /// + (0x200) - (0xFFF) Program Memory

    private var memory = [UInt8!](repeating:nil, count:4096)
    
    ///Special register to store memory addresses
    private var iRegister : UInt16 = 0
    
    //Hex Keypad
    private var button = [Bool!](repeating:nil, count: 16)
    
    ///Program Counter
    private var pc : UInt16 = 0x200
    
    private var stackSize : Int = 0
    
    private var screen : Screen!
    
    private var delayTimer : UInt8 = 0
    
    private var soundTimer : UInt8 = 0
    
    
    
    init(screen: Screen) {
        self.screen = screen
        for i in 0..<16{
            button[i] = false
            v[i] = 0
        }
        for i in 0..<memory.count{
            memory[i] = 0
        }
        hecadecimalSprites()
        loadGameToMemory()
    }
    
    
    public func run(){
        var operation : UInt16
        while(true){
            operation = UInt16(memory[Int(pc)])<<8 | UInt16(memory[Int(pc)+1])
            let str = String(format: "%X", operation)
            print("Executando operacao \(str)")
            try! op(op: operation)
            pc += 2
            usleep(50000)
            
        }
    }
    
    
    private func loadGameToMemory(){
        let a = FileHandle.init(forReadingAtPath: "/Users/Kaue/Documents/INVADERS")
        let num = Int((a?.seekToEndOfFile())!)
        a?.seek(toFileOffset: 0)
        for i in 0..<num{
            memory[0x200 + i] = (a?.readData(ofLength: 1).first)!
        }
    }
    
    private func hecadecimalSprites(){

        let hexSprites :[UInt8] =
        [0xF0, 0x90, 0x90, 0x90, 0xF0, //0
        0x20, 0x60, 0x20, 0x20, 0x70, //1
        0xF0, 0x10, 0xF0, 0x80, 0xF0, //2
        0xF0, 0x10, 0xF0, 0x10, 0xF0, //3
        0x90, 0x90, 0xF0, 0x10, 0x10, //4
        0xF0, 0x80, 0xF0, 0x10, 0xF0, //5
        0xF0, 0x80, 0xF0, 0x90, 0xF0, //6
        0xF0, 0x10, 0x20, 0x40, 0x40, //7
        0xF0, 0x90, 0xF0, 0x90, 0xF0, //8
        0xF0, 0x90, 0xF0, 0x10, 0xF0, //9
        0xF0, 0x90, 0xF0, 0x90, 0x90, //A
        0xE0, 0x90, 0xE0, 0x90, 0xE0, //B
        0xF0, 0x80, 0x80, 0x80, 0xF0, //C
        0xE0, 0x90, 0x90, 0x90, 0xE0, //D
        0xF0, 0x80, 0xF0, 0x80, 0xF0, //E
        0xF0, 0x80, 0xF0, 0x80, 0x80  //F
        ]
        memory.removeLast(hexSprites.count)
        memory = hexSprites + memory
        
        
    }
    
    
    
    
    public func teste(){
        var initialState = [Bool!](repeating: nil, count: 16)
        
        for i in 0..<16{
            initialState[i] = button[i]
        }
        
        var a = true
        while(a){
            for i in 0..<16{
                print(i)
                if(initialState[i] == false){
                    if(button[i] == true){
                        a = false
                    }
                }else{
                   initialState[i] = button[i]
                }
            }
        }        
    }
    
    
    
    
    
    //# MARK: - Private Methods
    
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
    
    
    private func pushToStack(num: UInt16) throws{
        let lastBytes: UInt8 = UInt8(num&0xff)
        let firstBytes: UInt8 = UInt8((num>>8)&0x0f)
        
        if(stackSize<16){
            memory[0x1FF - stackSize*2] = lastBytes
            memory[0x1FF - stackSize*2 - 1] = firstBytes
            stackSize+=1
        }else{
            throw Chip8Error.StackOverFlow
        }
    }
    
    private func popFromStack() throws -> UInt16{
        if(stackSize>0){
            stackSize-=1
            let firstBytes : UInt8 = memory[0x1FF - stackSize*2 - 1]
            let lastBytes : UInt8 = memory[0x1FF - stackSize*2]
            let result : UInt16 = ( UInt16(firstBytes) << 8) | UInt16(lastBytes)
            return result
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
    
    //# MARK: - Public Methods
    
    public func op(op: UInt16) throws {
        let d : UInt8 = UInt8(op & 0xf)
        let c : UInt8 = UInt8((op>>4) & 0xf)
        let b : UInt8 = UInt8((op>>8) & 0xf)
        let a : UInt8 = UInt8((op>>12) & 0xf)
        
        switch (a,b,c,d) {
            /*
            0nnn - SYS addr
            Jump to a machine code routine at nnn.
            
            This instruction is only used on the old computers on which Chip-8 was originally implemented. It is ignored by modern interpreters.
            */
//        case (0,_,_,_):
//            //# TODO: - Verificar validade dessa op
//            print("Ignored Instruction")
//            
            /*
            00E0 - CLS
            Clear the display.
            */
        case (0,0,0xE,0):
            screen.clear()

            
            /*
            00EE - RET
            Return from a subroutine.
            
            The interpreter sets the program counter to the address at the top of the stack, then subtracts 1 from the stack pointer.
            */
        case (0,0,0xE,0xE):
            try! pc = popFromStack()
            
            /*
            1nnn - JP addr
            Jump to location nnn.
            
            The interpreter sets the program counter to nnn.
            */
        case (1,_,_,_):
            pc = (UInt16(b)<<8|UInt16(c<<4)|UInt16(d))
            
            
            /*
            2nnn - CALL addr
            Call subroutine at nnn.
            
            The interpreter increments the stack pointer, then puts the current PC on the top of the stack. The PC is then set to nnn.
            */
        case (2,_,_,_):
            try! pushToStack(num: pc)
            pc = (UInt16(b)<<8)|UInt16(c)<<4|UInt16(d)
            
            
            
            /*
            3xkk - SE Vx, byte
            Skip next instruction if Vx = kk.
            
            The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
             */
        case (3,_,_,_):
            if( v[Int(b)] == (c<<4|d)){
                pc+=2
            }
            
            
            /*
            4xkk - SNE Vx, byte
            Skip next instruction if Vx != kk.
            
            The interpreter compares register Vx to kk, and if they are not equal, increments the program counter by 2.
            */
        case (4,_,_,_):
            if( v[Int(b)] != (c<<4|d)){
                pc+=2
            }

            
            
            
            /*
            5xy0 - SE Vx, Vy
            Skip next instruction if Vx = Vy.
            
            The interpreter compares register Vx to register Vy, and if they are equal, increments the program counter by 2.
            */
        case (5,_,_,0):
            if( v[Int(b)] == v[Int(c)]){
                pc+=2
            }
            
            
            
            /*
            6xkk - LD Vx, byte
            Set Vx = kk.
            
            The interpreter puts the value kk into register Vx.
            */
        case (6,_,_,_):
            v[Int(b)] = (c<<4|d)
            
            
            
            /*
            7xkk - ADD Vx, byte
            Set Vx = Vx + kk.
            
            Adds the value kk to the value of register Vx, then stores the result in Vx.
        
             */
        case (7,_,_,_):
            v[Int(b)] = UInt8((Int(v[Int(b)]) + Int(op & 0xFF))&0xff)


            
            
            
            /*
            8xy0 - LD Vx, Vy
            Set Vx = Vy.
            
            Stores the value of register Vy in register Vx.
            
            */
        case (8,_,_,0):
            v[Int(b)] = v[Int(c)]

            
            
            
            /*
            8xy1 - OR Vx, Vy
            Set Vx = Vx OR Vy.
            
            Performs a bitwise OR on the values of Vx and Vy, then stores the result in Vx. A bitwise OR compares the corrseponding bits from two values, and if either bit is 1, then the same bit in the result is also 1. Otherwise, it is 0.
            
            */
        case (8,_,_,1):
            v[Int(b)] = v[Int(b)] | v[Int(c)]
            
            
            
            /*
            8xy2 - AND Vx, Vy
            Set Vx = Vx AND Vy.
            
            Performs a bitwise AND on the values of Vx and Vy, then stores the result in Vx. A bitwise AND compares the corrseponding bits from two values, and if both bits are 1, then the same bit in the result is also 1. Otherwise, it is 0.
            */
        case (8,_,_,2):
            v[Int(b)] = v[Int(b)] & v[Int(c)]
            
            
            
            /*
            8xy3 - XOR Vx, Vy
            Set Vx = Vx XOR Vy.
            
            Performs a bitwise exclusive OR on the values of Vx and Vy, then stores the result in Vx. An exclusive OR compares the corrseponding bits from two values, and if the bits are not both the same, then the corresponding bit in the result is set to 1. Otherwise, it is 0.
            */
        case (8,_,_,3):
            v[Int(b)] = v[Int(b)]^v[Int(c)]
            
            
            
            /*
            8xy4 - ADD Vx, Vy
            Set Vx = Vx + Vy, set VF = carry.
            
            The values of Vx and Vy are added together. If the result is greater than 8 bits (i.e., > 255,) VF is set to 1, otherwise 0. Only the lowest 8 bits of the result are kept, and stored in Vx.
            */
        case (8,_,_,4):
            let sum : UInt16 = UInt16(v[Int(b)])+UInt16(v[Int(c)])
            v[Int(0xF)] = UInt8(sum>>8)&1
            v[Int(b)] = UInt8(sum&0xff)
            
            
            
            
            /*
            8xy5 - SUB Vx, Vy
            Set Vx = Vx - Vy, set VF = NOT borrow.
            
            If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
            */
        case (8,_,_,5):
            if(v[Int(b)]>v[Int(c)]){
                v[Int(0xF)] = 1
                v[Int(b)] = v[Int(b)] - v[Int(c)]
            }else{
                v[Int(0xF)] = 0
                v[Int(b)] = v[Int(c)] - v[Int(b)]
            }
            
            
            
            /*
            8xy6 - SHR Vx {, Vy}
        Set Vx = Vx SHR 1.
        
        If the least-significant bit of Vx is 1, then VF is set to 1, otherwise 0. Then Vx is divided by 2.
            */
        case (8,_,_,6):
            v[Int(0xF)] = v[Int(c)]%2
            v[Int(b)] = v[Int(c)]>>1
            
            /*
             8xy7 - SUBN Vx, Vy
        Set Vx = Vy - Vx, set VF = NOT borrow.
        
        If Vy > Vx, then VF is set to 1, otherwise 0. Then Vx is subtracted from Vy, and the results stored in Vx.
        */
        case (8,_,_,7):
            if(v[Int(c)]>v[Int(c)]){
                v[Int(0xF)] = 1
                v[Int(b)] = v[Int(c)] - v[Int(b)]
            }else{
                v[Int(0xF)] = 0
                v[Int(b)] = v[Int(b)] - v[Int(c)]
            }
            
            
            
            /*
        8xyE - SHL Vx {, Vy}
        Set Vx = Vx SHL 1.
        
        If the most-significant bit of Vx is 1, then VF is set to 1, otherwise to 0. Then Vx is multiplied by 2.
        */
        case (8,_,_,0xE):
            v[Int(0xF)] = v[Int(c)]>>7
            v[Int(b)] = v[Int(c)]<<1
            
            
            
            /*
        9xy0 - SNE Vx, Vy
        Skip next instruction if Vx != Vy.
        
        The values of Vx and Vy are compared, and if they are not equal, the program counter is increased by 2.
        */
        case (9,_,_,0):
            if(v[Int(b)] != v[Int(c)]){
                pc+=2
            }
            
            
            
            /*
        Annn - LD I, addr
        Set I = nnn.
        
        The value of register I is set to nnn.
        */
        case (0xA,_,_,_):
            iRegister = (UInt16(b)<<8|UInt16(c)<<4|UInt16(d))

            
            
        /*
        Bnnn - JP V0, addr
        Jump to location nnn + V0.
        
        The program counter is set to nnn plus the value of V0.
        */
        case (0xB,_,_,_):
            pc = UInt16((b<<8)|(c<<4)|(d)) + UInt16(v[0])
            
            
            
            /*
        Cxkk - RND Vx, byte
        Set Vx = random byte AND kk.
        
        The interpreter generates a random number from 0 to 255, which is then ANDed with the value kk. The results are stored in Vx. See instruction 8xy2 for more information on AND.
        */
        case (0xC,_,_,_):
            v[Int(b)] = UInt8(arc4random_uniform(256)) & (c<<4|d)
            
            
            
            
            /*
        Dxyn - DRW Vx, Vy, nibble
        Display n-byte sprite starting at memory location I at (Vx, Vy), set VF = collision.
        
        The interpreter reads n bytes from memory, starting at the address stored in I. These bytes are then displayed as sprites on screen at coordinates (Vx, Vy). Sprites are XORed onto the existing screen. If this causes any pixels to be erased, VF is set to 1, otherwise it is set to 0. If the sprite is positioned so part of it is outside the coordinates of the display, it wraps around to the opposite side of the screen. See instruction 8xy3 for more information on XOR, and section 2.4, Display, for more information on the Chip-8 screen and sprites.
             
            */
        case (0xD,_,_,_):
            var notCollision = true
            for i in 0..<Int(d){
                let drawBuffer = memory[Int(iRegister) + i]
                for j in 0..<8{
                    if( drawBuffer! & UInt8(0x80 >> j) != 0){
                        notCollision = notCollision && screen.drawPixel(x: Int(v[Int(b)]) + j, y: Int(v[Int(c)]) + i)
                    }
                }
            }
            if(notCollision){
                v[Int(0xF)] = 0
            }else{
                v[Int(0xF)] = 1
            }
            
            
            
            
            
            /*
        Ex9E - SKP Vx
        Skip next instruction if key with the value of Vx is pressed.
        
        Checks the keyboard, and if the key corresponding to the value of Vx is currently in the down position, PC is increased by 2.
        */
        case (0xE,_,9,0xE):
            if( button[Int(v[Int(b)])] == true ){
                pc += 2
            }
            
            
            
            /*
        ExA1 - SKNP Vx
        Skip next instruction if key with the value of Vx is not pressed.
        
        Checks the keyboard, and if the key corresponding to the value of Vx is currently in the up position, PC is increased by 2.
        */
        case (0xE,_,0xA,1):
            if(!button[Int(v[Int(b)])]){
                pc += 2
            }
            
           
            
            /*
        Fx07 - LD Vx, DT
        Set Vx = delay timer value.
        
        The value of DT is placed into Vx.
        */
        case (0xF,_,0,7):
            v[Int(b)] = delayTimer
            
            
            
            /*
        Fx0A - LD Vx, K
        Wait for a key press, store the value of the key in Vx.
        
        All execution stops until a key is pressed, then the value of that key is stored in Vx.
        */
        case (0xF,_,0,0xA):
            var initialState = [Bool!](repeating: nil, count: 16)
            
            for i in 0..<16{
                initialState[i] = button[i]
            }
            
            var check = true
            while(check){
                for i in 0..<16{
                    print(i)
                    if(initialState[i] == false){
                        if(button[i] == true){
                            check = false
                        }
                    }else{
                        initialState[i] = button[i]
                    }
                }
            }        

            
        
            
            /*
        Fx15 - LD DT, Vx
        Set delay timer = Vx.
        
        DT is set equal to the value of Vx.
        */
        case (0xF,_,1,5):
            delayTimer = v[Int(b)]
            
            
            
            /*
        Fx18 - LD ST, Vx
        Set sound timer = Vx.
        
        ST is set equal to the value of Vx.
        */
        case (0xF,_,1,8):
            soundTimer = v[Int(b)]
            
            
            
            /*
        Fx1E - ADD I, Vx
        Set I = I + Vx.
        
        The values of I and Vx are added, and the results are stored in I.
        */
        case (0xF,_,1,0xE):
            iRegister = iRegister + UInt16(v[Int(b)])
            
            
            
            /*
        Fx29 - LD F, Vx
        Set I = location of sprite for digit Vx.
        
        The value of I is set to the location for the hexadecimal sprite corresponding to the value of Vx. See section 2.4, Display, for more information on the Chip-8 hexadecimal font.
        */
        case (0xF,_,2,9):
            //# TODO: Preencher memoria com sprites de digitos HEX
            iRegister = UInt16(Int(b)*5)
            
            
            
            /*
        Fx33 - LD B, Vx
        Store BCD representation of Vx in memory locations I, I+1, and I+2.
        
        The interpreter takes the decimal value of Vx, and places the hundreds digit in memory at location in I, the tens digit at location I+1, and the ones digit at location I+2.
        */
        case (0xF,_,3,3):
            memory[Int(iRegister)] = UInt8(getDig(dig: Int(v[Int(b)]), pos: 2))
            memory[Int(iRegister) + 1] = UInt8(getDig(dig: Int(v[Int(b)]), pos: 1))
            memory[Int(iRegister) + 2] = UInt8(getDig(dig: Int(v[Int(b)]), pos: 0))
            
            
            
            /*
        Fx55 - LD [I], Vx
        Store registers V0 through Vx in memory starting at location I.
        
        The interpreter copies the values of registers V0 through Vx into memory, starting at the address in I.
        */
        case (0xF,_,5,5):
            for i in 0...Int(b){
                memory[Int(iRegister) + i] = v[i]
            }
            iRegister = iRegister + UInt16(b) + UInt16(1)
            
            
            /*
        Fx65 - LD Vx, [I]
        Read registers V0 through Vx from memory starting at location I.
        
        The interpreter reads values from memory starting at location I into registers V0 through Vx.*/
        case (0xF,_,6,5):
            for i in 0...Int(b){
                v[i] = memory[Int(iRegister) + i]
            }
            iRegister = iRegister + UInt16(b) + UInt16(1)
        default:
            print("OPS, UNKNOWN INSTRUCTION")
        }
        
    }
    
    
    public func pressButton(key: Int){
        button[key] = true
    }
    
    public func releaseButton(key: Int){
        button[key] = false
    }
    
    //# MARK: -Math help Functions
    
    private func getDig(dig: Int, pos: Int) -> Int{
        let a = dig/Int(NSDecimalNumber(decimal: pow(10,pos)))
        let b = a - (a/10)*10
        return b
    }
    
    
    
    
    
    
    

}
