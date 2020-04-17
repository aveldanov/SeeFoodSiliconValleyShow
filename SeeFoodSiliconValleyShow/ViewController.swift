//
//  ViewController.swift
//  SeeFoodSiliconValleyShow
//
//  Created by Veldanov, Anton on 4/16/20.
//  Copyright © 2020 Anton Veldanov. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  
  @IBOutlet weak var imageView: UIImageView!
  
  let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    imagePicker.delegate = self
    imagePicker.sourceType = .camera
    imagePicker.allowsEditing = false // normally true
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
      imageView.image = userPickedImage
      
      
      guard let ciimage = CIImage(image: userPickedImage) else {
        
        fatalError("Error: could not convert to CIImage")
      }
      
      detect(image: ciimage)
      
    }
    
    imagePicker.dismiss(animated: true, completion: nil)
    
    
  }
  
  
  func detect(image: CIImage){
   // VNCoreMLModel is part of Vision Framework -> image analys
      guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
        fatalError("Error: Loading CoreML failed")
      }
    let request = VNCoreMLRequest(model: model) { (request, error) in
      guard let results = request.results as? [VNClassificationObservation] else{
        fatalError("Error: Model failed to process image")
      }
      
      if let firstResult = results.first{
        print("RESULT: ",firstResult.identifier)
        if firstResult.identifier.contains("hotdog"){
          self.navigationItem.title = "It is a Hot Dog"
          UINavigationBar.appearance().barTintColor = UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 102.0/255.0, alpha: 1.0)


        }else{
          self.navigationItem.title = "Nah, \(firstResult.identifier)"
            UINavigationBar.appearance().barTintColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        }
      }
      print(results)
    }
    
    let handler = VNImageRequestHandler(ciImage: image)
    do{
      try handler.perform([request])
    }catch{
      print(error)
    }
    
    
  }
  
  
  
  

  @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
    
    present(imagePicker, animated: true, completion: nil)
    
  }
  
}

