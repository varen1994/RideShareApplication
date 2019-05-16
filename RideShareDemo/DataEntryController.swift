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
    
    @IBOutlet weak var bottomConstraintOfScrollView: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)

        
    }

    //MARK:- KEYBOARD NOTIFICATIONS
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomConstraintOfScrollView.constant == 0.0  {
                UIView.animate(withDuration: 1.0, animations: {
                     self.bottomConstraintOfScrollView.constant -= keyboardSize.height
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 1.0, animations: {
            self.bottomConstraintOfScrollView.constant = 0.0
            self.view.layoutIfNeeded()
        });
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
        
        if (doubleValueLatRiderHome.1  && doubleValueLongRiderHome.1 && doubleValueLatRiderOffice.1 && doubleValueLongRiderOffice.1 && doubleValueLatSharerHome.1 && doubleValueLongSharerHome.1 && doubleValueLatSharerOffice.1 && doubleValueLongSharerOffice.1 )
             {
            let coordinate1 = CLLocationCoordinate2D.init(latitude: doubleValueLatRiderHome.0, longitude: doubleValueLongRiderHome.0)
            let coordinate2 = CLLocationCoordinate2D.init(latitude: doubleValueLatRiderOffice.0, longitude: doubleValueLongRiderOffice.0)
            let coordinate3 = CLLocationCoordinate2D.init(latitude: doubleValueLatSharerHome.0, longitude: doubleValueLongSharerHome.0)
            let coordinate4 = CLLocationCoordinate2D.init(latitude: doubleValueLatSharerOffice.0, longitude: doubleValueLongSharerOffice.0)
            
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            nextVC.coordinatedOfRiderHome = coordinate1;
            nextVC.coordinatedOfRiderOffice = coordinate2;
            nextVC.coordinatedOfSharerHome = coordinate3;
            nextVC.coordinatedOfSharerOffice = coordinate4;
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
            self.showAlertViewWithAlert(message: "Invalid input.")
            return ;
        }
    }
    
    
    //MARK:- ALERT VIEW
    func showAlertViewWithAlert(message:String) {
        let alertController = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert);
        let alertActionOk = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertActionOk);
        self.present(alertController, animated: true, completion: nil);
    }
    
    
    func changeIntoFloatOrGive(text:UITextField)->(Double,Bool) {
        if let lat = text.text, let doubleLat = Double(lat) {
            return (doubleLat,true) // doubleLat is of type Double now
        }
        return (0.0,false);
    }
    
    
    //MARK:- ******* <UITextFieldDelegate> **********
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true;
    }
}
