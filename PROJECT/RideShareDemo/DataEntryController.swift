//
//  DataEntryController.swift
//  RideShareDemo
//
//  Created by Varender Singh on 16/05/19.
//  Copyright © 2019 Varender Singh. All rights reserved.
//

import UIKit
import MapKit

class DataEntryController: UIViewController,UITextFieldDelegate {
    
    // Riders Data
    @IBOutlet weak var textFieldLatRiderHome: UITextField!
    @IBOutlet weak var textFieldLongRiderHome: UITextField!
    @IBOutlet weak var textFieldLatOfficeCoordinates: UITextField!
    @IBOutlet weak var textFieldLongOfficeCoordinates: UITextField!
    
    // Sharer Data
    @IBOutlet weak var textFiledLatSharerHome: UITextField!
    @IBOutlet weak var textFieldLongSharerHoe: UITextField!
    @IBOutlet weak var textFieldLatSharerOffice: UITextField!
    @IBOutlet weak var textFieldLongSharerOffice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- ******* ACTIONS **********
    @IBAction func doneBtnClicked(_ sender: Any) {
        let doubleValueLatRiderHome = self.changeIntoFloatOrGive(text:self.textFieldLatRiderHome)
        let doubleValueLongRiderHome = self.changeIntoFloatOrGive(text:self.textFieldLongRiderHome)
        let doubleValueLatRiderOffice = self.changeIntoFloatOrGive(text:self.textFieldLatOfficeCoordinates)
        let doubleValueLongRiderOffice = self.changeIntoFloatOrGive(text:self.textFieldLongOfficeCoordinates)
        
        
        let doubleValueLatSharerHome = self.changeIntoFloatOrGive(text:self.textFiledLatSharerHome)
        let doubleValueLongSharerHome = self.changeIntoFloatOrGive(text:self.textFieldLongSharerHoe)
        let doubleValueLatSharerOffice = self.changeIntoFloatOrGive(text:self.textFieldLatSharerOffice)
        let doubleValueLongSharerOffice = self.changeIntoFloatOrGive(text:self.textFieldLongSharerOffice)
        
        
        let coordinate1 = CLLocationCoordinate2D.init(latitude: doubleValueLatRiderHome, longitude: doubleValueLongRiderHome)
        let coordinate2 = CLLocationCoordinate2D.init(latitude: doubleValueLatRiderOffice, longitude: doubleValueLongRiderOffice)
        let coordinate3 = CLLocationCoordinate2D.init(latitude: doubleValueLatSharerHome, longitude: doubleValueLongSharerHome)
        let coordinate4 = CLLocationCoordinate2D.init(latitude: doubleValueLatSharerOffice, longitude: doubleValueLongSharerOffice)
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        nextVC.coordinatedOfRiderHome = coordinate1;
        nextVC.coordinatedOfRiderOffice = coordinate2;
        nextVC.coordinatedOfSharerHome = coordinate3;
        nextVC.coordinatedOfSharerOffice = coordinate4;
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func changeIntoFloatOrGive(text:UITextField)->Double {
        if let lat = text.text, let doubleLat = Double(lat) {
            return doubleLat // doubleLat is of type Double now
        }
        return 0.0;
    }
    
    
    //MARK:- ******* <UITextFieldDelegate> **********
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true;
    }
}
