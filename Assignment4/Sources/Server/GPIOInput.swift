//
//  GPIOInput.swift
//  Bluetooth
//
//  Created by Van Simmons on 4/21/19.
//

import Foundation
import SwiftyLinkerKit
import HeliumLogger
import LoggerAPI

struct GPIOInput {
    static let logger = HeliumLogger()
    static let touchSensor = LKButton2()
    
    /*
     Question 1 a create a variable called pot, of type LKTemp
     give it a sample interval of 200ms and a value type of voltage
     depending on which sensor you have
    */
    static let pot = LKTemp(interval: 0.2, valueType: .voltage)
    static var potValue = 0.0

    static func handleGPIOInput() {
        // You may uncomment these out and use them
        guard let shield  = LKRBShield.default else { return }
        Log.logger = logger

        // Digital On/Off Sensor
        /*
         Question 1 b connect a touch sensor to location row 1 col 5
         on your board and initialize the shield connection
         */
        shield._connect(touchSensor, to: .digital1718)

        /*
         Question 1 c provide an onChange1 method for the touchSensor
         which changes the state of the LED to match the state of the sensor
         if you are using a button, toggle the LED state.
         Be sure to log changes to the logger.
         */
        touchSensor.onChange1 { (isTouched) in
            Log.info("isTouched = \(isTouched)")
            LEDService.led.on = isTouched
        }
        
        // Analog device
        /*
         Question 1 d connect the pot variable you created above
         to location row 1 col 1 on your board and initialize the shield connection
         */
        shield._connect(pot, to: .analog01)
        
        /*
         Question 1 e provide an onChange method for the potentiometer
         updates the var potValue the current state of the potentiometer
         prints it out using the logger variable at the top of the this function
         */
        pot.onChange { (temperature) in
            potValue = temperature
            Log.info("Potentiometer raw value is \(potValue)")
        }
    }
}
