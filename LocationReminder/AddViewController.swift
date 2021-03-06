//
//  AddViewController.swift
//
//  Created by MINA FUJISAWA on 2017/10/08.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import GooglePlaces

class AddViewController: UIViewController {
    let placeListKey: String = PlaceListViewController().placeListKey
    var prediction: GMSAutocompletePrediction?

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!

    @IBAction func doneButton(_ sender: Any) {
        // Get lat and lon
        let geocoder = CLGeocoder()
        print("current address \((prediction?.attributedFullText.string)!)")
        geocoder.geocodeAddressString((prediction?.attributedFullText.string)!) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude

            // Add new Place
            let newPlace = Place(message: self.messageTextField.text!, placeName: (self.prediction?.attributedPrimaryText.string)!, fullAddress: (self.prediction?.attributedFullText.string)!, lat: lat!, lon: lon!)
            let listVC = PlaceListViewController()
            listVC.placeList?.append(newPlace)
            let defaults = UserDefaults.standard
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: listVC.placeList!), forKey: self.placeListKey)

            // Back to List page
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "placeList") as! PlaceListViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // MARK: Message text field
        messageTextField.delegate = self
        messageTextField.becomeFirstResponder()
        messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let prediction = prediction else { return }
        addressLabel.attributedText = prediction.attributedFullText
    }
}

extension AddViewController: UITextFieldDelegate {
    //Close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
  
}

