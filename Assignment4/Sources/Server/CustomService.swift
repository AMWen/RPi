//
//  CustomService.swift
//  Server
//
//  Created by Van Simmons on 4/22/19.
//

import Foundation
import Bluetooth
#if os(Linux)
import GATT
import BluetoothLinux

public final class GATTCustomServiceController: GATTServiceController {
    public static let service: BluetoothUUID =
        /* Question 1.1 create a valid UUIDs for your service and characteristics using the techniques shown in class
         */
        // Used uuidgen
        BluetoothUUID(uuid: UUID(uuidString: "2B53C3E5-9F0B-443D-85DE-B3B0A0409CB4")!)
    public static let notifyUuid = BluetoothUUID(uuid: UUID(uuidString: "5471B0EC-956C-49B2-8645-D8BEE8B80459")!)
    public static let writeUuid = BluetoothUUID(uuid: UUID(uuidString: "C255C9BB-4517-4769-A2D8-D7E13B9F43BF")!)
    
    
    public let peripheral: PeripheralManager
    
    /* Question 1.2, When notifyValue changes
     write a UTF string value to notifyHandle and call update values
     */
    public var notifyValue = "" {
        didSet {
            print("did set notifyValue")
            updateValues()
        }
    }
    
    /* Question 1.3, when writeValue changes
     set the state of notifyValue to match it
     */
    public var writeValue: UInt8 = 0 {
        didSet {
            print("did Set writeValue\(writeValue)")
            notifyValue = "New value: \(writeValue)"
        }
    }
    internal let serviceHandle: UInt16
    internal let notifyHandle: UInt16
    internal let writeHandle: UInt16
    
    // MARK: - Initialization
    
    public init(peripheral: PeripheralManager) throws {
        self.peripheral = peripheral
        let serviceUUID = type(of: self).service
        
        let descriptors = [GATTClientCharacteristicConfiguration().descriptor]
        
        let characteristics = [
            /* Question 1.4 assign the following characteristic permissions of read and properties of notify
             */
            GATT.Characteristic(uuid: GATTCustomServiceController.notifyUuid,
                                value: notifyValue.data(using: .utf8)!,
                                permissions: [.read],
                                properties: [.notify],
                                descriptors: descriptors),
            
            /* Question 1.5 assign the following characteristic permissions of read and write and properties of read and write and give the characteristic an initial value of 0x0
             */
            GATT.Characteristic(uuid: GATTCustomServiceController.writeUuid,
                                value: Data([0x0]),
                                permissions: [.read, .write],
                                properties: [.read, .write],
                                descriptors: descriptors)
        ]
        
        let service = GATT.Service(uuid: serviceUUID,
                                   primary: true,
                                   characteristics: characteristics)
        
        self.serviceHandle = try peripheral.add(service: service)
        self.notifyHandle = peripheral.characteristics(for: GATTCustomServiceController.notifyUuid)[0]
        self.writeHandle = peripheral.characteristics(for: GATTCustomServiceController.writeUuid)[0]
        
        self.peripheral.willWrite = { [weak self] (request) -> ATT.Error? in
            guard let self = self else { return nil }
            switch request.uuid {
            case GATTCustomServiceController.writeUuid:
                let value = request.newValue[0]
                self.writeValue = value
                return nil
                
            default:
                return nil
            }
        }
    }
    
    deinit {
        self.peripheral.remove(service: serviceHandle)
    }
    
    // MARK: - Methods
    func updateValues() {
        peripheral[characteristic: notifyHandle] = notifyValue.data(using: .utf8)!
    }
}

#endif

