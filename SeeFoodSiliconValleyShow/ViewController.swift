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
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = false // normally true
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
      imageView.image = userPickedImage
      
      
      guard let ciimage = CIImage(image: userPickedImage) else {
        
        fatalError("Error: could not convert to CIImage")
      }
      
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
    }
    
  }
  
  
  
  

  @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
    
    present(imagePicker, animated: true, completion: nil)
    
  }
  
}

