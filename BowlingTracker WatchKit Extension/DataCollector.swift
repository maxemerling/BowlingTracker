//
//  DataCollector.swift
//  MotionTracker WatchKit Extension
//
//  Created by Max Emerling on 2/29/20.
//  Copyright © 2020 MDB. All rights reserved.
//

import WatchKit
import CoreMotion

protocol DataCollectorDelegate: class {
    func didUpdateMotion(_ manager: DataCollector, data: MotionData)
}

class DataCollector {

    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    weak var delegate: DataCollectorDelegate?
    
    //50 Hz
    let sampleInterval = 1.0/50
    
    func startCollection() {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = sampleInterval
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }

            if deviceMotion != nil {
                self.processMotion(deviceMotion!)
                
            }
        }
    }
    
    init() {
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "DataQueue"
    }
    
    func stopCollection() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    func processMotion(_ deviceMotion: CMDeviceMotion) {
        let accel = deviceMotion.userAcceleration
        let rot = deviceMotion.rotationRate
        let data = MotionData(accelX:accel.x, accelY:accel.y, accelZ:accel.z,
                              rotX:rot.x, rotY:rot.y, rotZ:rot.z)
        
        delegate?.didUpdateMotion(self, data:data)
    }
}

struct MotionData: Codable {
    let accelX: Double
    let accelY: Double
    let accelZ: Double
    
    let rotX: Double
    let rotY: Double
    let rotZ: Double
}
