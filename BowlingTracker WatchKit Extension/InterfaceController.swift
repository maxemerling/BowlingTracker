//
//  InterfaceController.swift
//  BowlingTracker WatchKit Extension
//
//  Created by Max Emerling on 3/7/20.
//  Copyright © 2020 MDB. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, DataCollectorDelegate {
    func didUpdateMotion(_ manager: DataCollector, data: MotionData) {
        DispatchQueue.main.async {
            self.rLabel.setText("Rot: \(data.rotX), \(data.rotY), \(data.rotZ)")
            self.aLabel.setText("Accel: \(data.accelX), \(data.accelY), \(data.accelZ)")
        }
    }
    
    @IBOutlet weak var rLabel: WKInterfaceLabel!
    @IBOutlet weak var aLabel: WKInterfaceLabel!
    
    var started = false
    let collector = DataCollector()
    
    @IBOutlet weak var button: WKInterfaceButton!
    
    @IBAction func buttonTapped() {
        if (started) {
            started = false
            collector.stopCollection()
            button.setTitle("Start")
        } else {
            started = true
            collector.startCollection()
            button.setTitle("Stop")
        }
    }

    override init() {
        super.init()
        
        collector.delegate = self
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
