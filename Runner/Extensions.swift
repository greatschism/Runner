//
//  Extensions.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-03-06.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit

extension UIView {
    
    func renderToImage() -> UIImage? {
        
        UIGraphicsBeginImageContext(self.frame.size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCache(with imageURL: String) {
        
        self.image = nil
        
        // check for cached image first
        if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
            
            self.image = cachedImage
            return
        }
        
        // otherwise start a a new download
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                
                print(error.debugDescription)
                return
            }
            
            DispatchQueue.main.async {
                
                guard let data = data else { return }
                if let downloadedImage = UIImage(data: data) {
                    
                    imageCache.setObject(downloadedImage, forKey: imageURL as NSString)
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
