//
//  ViewControllerML.swift
//  TestCard
//
//  Created by Nathaniel Putera on 28/03/19.
//  Copyright © 2019 Nathaniel Putera. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

class ViewControllerML: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Cannot convert UIImage to CIImage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect (image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Failed to load model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            print(results)
            if let firstResult = results.first {
                let str = "\(firstResult.identifier)"
                if str.contains(","){
                    let r = str.index(str.startIndex, offsetBy: 0)..<str.index(str.firstIndex(of: ",")!, offsetBy: 0)
                    self.navigationItem.title = String(str[r]).capitalized
                    self.request(imageName: String(str[r]))
                } else {
                    self.navigationItem.title = firstResult.identifier.capitalized
                    self.request(imageName: firstResult.identifier)
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    func request (imageName: String) {
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "description",
            "titles" : imageName,
            "indexpageids" : "",
            "redirects" : "1",
            ]
        
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print(response)
                
                let tempJSON: JSON = JSON(response.result.value!)
                let pageid = tempJSON["query"]["pageids"][0].stringValue
                let temp = tempJSON["query"]["pages"][pageid]["description"].stringValue
                
                self.desc.text = temp
                
            }
        }
        
    }
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func libraryTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
