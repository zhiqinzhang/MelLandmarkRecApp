//
//  ViewController.swift
//  LandmarksRecApp
//
//  Created by Zhiqin Zhang on 2019/4/28.
//  Copyright © 2019 Zhiqin Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
//import AFNetworking


let URL_PATH_RECEIVE : String = "http://192.168.0.11:5000/receive"
let URL_PATH_INITIALIZE : String = "http://192.168.0.11:5000/initialize"
var uploadImg : String = ""

class ViewController: UIViewController,  UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var progressView = UIView()
    var notifyView = UIView()
    var initiallocation: [Double] = [-37.8105371797142,144.962749729496]
    var local_data: [String: AnyObject] = [:]
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. We want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let imagetoUpload = selectedImage.jpegData(compressionQuality: 0.5)!
        let base64Image = imagetoUpload.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        uploadImg = base64Image
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func takePhotoFromCamera(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectPhotoFromLib(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func printDate(string: String) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSSS"
        print(string + formatter.string(from: date))
    }
    
    @IBAction func singleImgUpload(_ sender: UIButton) {
        if uploadImg == "" {
            notificationBeforeUpload()
            return
        }
        let parameters:[String:String] = ["image": uploadImg]
        print("begin")
        identificationProgress()
        Alamofire.request(URL_PATH_RECEIVE, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success(let json):
                print("a response from the server")
                let dict = json as! Dictionary<String,AnyObject>
                let label = dict["label"] as! String
                let coordinate = dict["coordinate"] as! [String]
                self.initiallocation = coordinate.compactMap(Double.init)
                if let localData = dict["local data"] as? Dictionary<String, AnyObject> {
                    // do whatever with jsonResult
                    self.local_data = localData
                }
                self.resultLabel.text = label
                
                self.resultLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                
                self.progressView.removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
            case .failure(let error):
                print("no response from the server")
                print(error)
            }
        }
    }
    
    
    
    @IBAction func goToMap(_ sender: UIButton) {
        performSegue( withIdentifier: "mapViewSegue", sender: self)
    }
    
    func identificationProgress() {
        progressView = UIView(frame: CGRect(x: view.frame.midX - 95, y: view.frame.midY - 25, width: 190, height: 50))
        progressView.backgroundColor = UIColor.white
        progressView.alpha = 0.8
        progressView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: -5, width: 60, height: 60)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.black
        textLabel.text = "Recognizing..."
        
        progressView.addSubview(activityView)
        progressView.addSubview(textLabel)
        
        view.addSubview(progressView)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func notificationBeforeUpload() {
        notifyView = UIView(frame: CGRect(x: 102, y: 259, width: 210, height: 70))
        notifyView.backgroundColor = UIColor.white
        notifyView.alpha = 0.8
        notifyView.layer.cornerRadius = 10
        let textLabel = UILabel(frame: CGRect(x: 15, y: 9, width: 190, height: 52))
        textLabel.textColor = UIColor.black
        textLabel.text = "Please Select or Take a Photo Before Upload🤩"
        textLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        textLabel.numberOfLines = 2
        notifyView.addSubview(textLabel)
        view.addSubview(notifyView)
        UIView.animate(withDuration: 2.0, delay: 1.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.notifyView.alpha = 0.0
        }, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let MapViewController = segue.destination as? MapViewController {
            MapViewController.label = resultLabel.text!
            MapViewController.initiallocation = initiallocation
            MapViewController.local_data = local_data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named:"background")?.cgImage
        self.photoImageView.layer.borderWidth = 5
        self.photoImageView.layer.borderColor = UIColor.brown.cgColor
        self.photoImageView.layer.cornerRadius = 20
        self.photoImageView.clipsToBounds = true
        
        self.resultLabel.textAlignment = .center
        self.resultLabel.layer.borderWidth = 5
        self.resultLabel.layer.borderColor = UIColor.brown.cgColor
        // initial request to initialize the map data
        Alamofire.request(URL_PATH_INITIALIZE, method: .post, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success(let json):
                print("a response from the server==========")
                //                let json = JSON(response.result.value!)
                let dict = json as! Dictionary<String,AnyObject>
                let coordinate = dict["coordinate"] as! [String]
                self.initiallocation = coordinate.compactMap(Double.init)
                if let localData = dict["local data"] as? Dictionary<String, AnyObject> {
                    // do whatever with jsonResult
                    self.local_data = localData
                }
            case .failure(let error):
                print("no response from the server----------")
                print(error)
            }
        }
    }


}

