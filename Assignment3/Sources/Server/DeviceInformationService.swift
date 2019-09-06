//
//  DeviceInformationService.swift
//  gattserver
//
//

import Foundation
import Bluetooth

#if os(Linux)
import GATT
import BluetoothLinux

public final class GATTDeviceInformationServiceController: GATTServiceController {
    
    public static let service: BluetoothUUID = .deviceInformation
    
    // MARK: - Properties
    
    public let peripheral: PeripheralManager
    
    public private(set) var modelNumber: GATTModelNumber = ""
    public private(set) var serialNumber: GATTSerialNumberString = ""
    public private(set) var manufacturerName: GATTManufacturerNameString = ""
    public private(set) var firmwareRevision: GATTFirmwareRevisionString = ""
    public private(set) var softwareRevision: GATTSoftwareRevisionString = ""
    public private(set) var hardwareRevision: GATTHardwareRevisionString = ""
    public private(set) var pnpId = GATTPnPID(vendorIdSource: .fromAssignedNumbersDocument, vendorId: 0, productId: 0, productVersion: 0)
    public private(set) var systemId = GATTSystemID(manufacturerIdentifier: 0, organizationallyUniqueIdentifier: 0)
    
    internal let serviceHandle: UInt16
    
    internal let modelNumberHandle: UInt16
    internal let serialNumberHandle: UInt16
    internal let manufacturerNameHandle: UInt16
    internal let firmwareRevisionHandle: UInt16
    internal let softwareRevisionHandle: UInt16
    internal let hardwareRevisionHandle: UInt16
    internal let pnpIdHandle: UInt16
    internal let systemIdHandle: UInt16
    
    internal var timer: Timer!
    
    // MARK: - Initialization
    public init(peripheral: PeripheralManager) throws {
        
        self.peripheral = peripheral
        
        let serviceUUID = type(of: self).service
        let descriptors = [GATTClientCharacteristicConfiguration().descriptor]
        
        let characteristics = [
            GATT.Characteristic(uuid: type(of: modelNumber).uuid,
                                value: modelNumber.data,
                                permissions: [.read],
                                properties: [.read],
                                descriptors: descriptors),
            
            GATT.Characteristic(uuid: type(of: serialNumber).uuid,
                                value: serialNumber.data,
                                permissions: [.read],
                                properties: [.read],
                                descriptors: descriptors),
            
            GATT.Characteristic(uuid: type(of: manufacturerName).uuid,
                                value: manufacturerName.data,
                                permissions: [.read],
                                properties: [.read],
                                descriptors: descriptors),
            
            GATT.Characteristic(uuid: type(of: firmwareRevision).uuid,
                                value: firmwareRevision.data,
                                permissions: [.read],
                                properties: [.read],
                                descriptors: descriptors),
            
            GATT.Characteristic(uuid: type(of: softwareRevision).uuid,
                                value: softwareRevision.data,
                                permissions: [.read],
                                properties: [.read],
                                descriptors: descriptors),
            
            GATT.Characteristic(uuid: type(of: hardwareRevision).uuid,
                                value: hardwareRevision.data,
                                permissions: [.read],
                                properties: [.read],
                                descriptors: descriptors),
            
            GATT.Characteristic(uuid: type(of: pnpId).uuid,
                                value: pnpId.data,
                                permissions: [.read],
                                properties: [.read],
                                descriptors: descriptors),
            
            GATT.Characteristic(uuid: type(of: systemId).uuid,
                                value: systemId.data,
                                permissions: [.read],
                                properties: [.read],
                                descriptors: descriptors)
        ]
        
        let service = GATT.Service(uuid: serviceUUID,
                                   primary: true,
                                   characteristics: characteristics)
        
        self.serviceHandle = try peripheral.add(service: service)
        self.modelNumberHandle = peripheral.characteristics(for: type(of: modelNumber).uuid)[0]
        self.serialNumberHandle = peripheral.characteristics(for: type(of: serialNumber).uuid)[0]
        self.manufacturerNameHandle = peripheral.characteristics(for: type(of: manufacturerName).uuid)[0]
        self.firmwareRevisionHandle = peripheral.characteristics(for: type(of: firmwareRevision).uuid)[0]
        self.softwareRevisionHandle = peripheral.characteristics(for: type(of: softwareRevision).uuid)[0]
        self.hardwareRevisionHandle = peripheral.characteristics(for: type(of: hardwareRevision).uuid)[0]
        self.pnpIdHandle = peripheral.characteristics(for: type(of: pnpId).uuid)[0]
        self.systemIdHandle = peripheral.characteristics(for: type(of: systemId).uuid)[0]
        
        updateValues()
    }
    
    deinit {
        
        self.peripheral.remove(service: serviceHandle)
        
        self.timer?.invalidate()
    }
    
    // MARK: - Methods
    
    func updateValues() {
        modelNumber = ""
        serialNumber = ""
        manufacturerName = ""
        firmwareRevision = ""
        softwareRevision = ""
        hardwareRevision = ""
        pnpId = GATTPnPID(vendorIdSource: .fromAssignedNumbersDocument, vendorId: 0, productId: 0, productVersion: 0)
        systemId = GATTSystemID(manufacturerIdentifier: 101, organizationallyUniqueIdentifier: 340)
        
        peripheral[characteristic: modelNumberHandle] = modelNumber.data
        peripheral[characteristic: serialNumberHandle] = serialNumber.data
        peripheral[characteristic: manufacturerNameHandle] = manufacturerName.data
        peripheral[characteristic: firmwareRevisionHandle] = firmwareRevision.data
        peripheral[characteristic: softwareRevisionHandle] = softwareRevision.data
        peripheral[characteristic: hardwareRevisionHandle] = hardwareRevision.data
        peripheral[characteristic: pnpIdHandle] = pnpId.data
        peripheral[characteristic: systemIdHandle] = systemId.data
    }
}

#endif
