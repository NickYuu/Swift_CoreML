//
//  ViewController.swift
//  Whats_this_place
//
//  Created by TsungHan on 2017/7/19.
//  Copyright © 2017年 TsungHan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 輸入圖片大小須為224*224
    let inputSize =  CGSize(width: 224, height: 224)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var probabilityLB: UILabel!
    @IBOutlet weak var descriptionLB: UILabel!
    
    
    @IBAction func getPhoto(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil,
                                            message: "開始預測",
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "拍照", style: .default)
            { _ in self.takePhoto(from: .camera) }
        let library = UIAlertAction(title: "選擇", style: .default)
            { _ in self.takePhoto(from: .photoLibrary) }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(library)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func takePhoto(from source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}


extension ViewController {
    func predict(_ input: UIImage) {
        guard let ciImage = CIImage(image: input) else {
            fatalError("轉換 CIImage 失敗")
        }
        // 載入模型
        
        // 建立 Vision Request
        
        // 執行並處理 Request
        
    }
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
            
            UIGraphicsBeginImageContextWithOptions(inputSize, false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: inputSize.width, height: inputSize.height))
            guard let input = UIGraphicsGetImageFromCurrentImageContext() else {
                fatalError("圖片壓縮失敗")
            }
            UIGraphicsEndImageContext()
            predict(input)
        }
    }
}


