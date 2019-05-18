//
//  CameraPickerHandler.swift
//  MVVMShopApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import Foundation
import UIKit

class CameraPickerHandler: NSObject {
    static let shared = CameraPickerHandler()
    
    fileprivate var currentViewController: UIViewController!
    
    // MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = .camera
            currentViewController.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = .photoLibrary
            currentViewController.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(viewController: UIViewController, sourceView: UIView) {
        currentViewController = viewController
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Localify.get("alert.title.camera"), style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: Localify.get("alert.title.photos"), style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: Localify.get("toolbar.cancel"), style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController?.sourceView = sourceView
            actionSheet.popoverPresentationController?.sourceRect = sourceView.bounds
            actionSheet.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        currentViewController.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - UIIMagePicker Delegate, NavigationController Delegate
extension CameraPickerHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentViewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
        }
        else{
            print("Something went wrong")
        }
        currentViewController.dismiss(animated: true, completion: nil)
    }
}
