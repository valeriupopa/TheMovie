//
//  PhotoPickerViewModel.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/16/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit
import RxSwift

class PhotoPickerViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    private let picker = UIImagePickerController()
    private let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    let present = PublishSubject<UIViewController>()
    let didGetImageURL = PublishSubject<URL>()

    override init() {
        super.init()

        self.configurePicker()
        self.configureSourcePicker()
    }

    // MARK: - Private methods
    private func configurePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
             picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }

        picker.allowsEditing = false
        picker.delegate = self
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    }

    private func configureSourcePicker() {

        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { [unowned self] (action) in
            self.showCamera()
        })

        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { [unowned self] (action) in
            self.showGallery()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] (action) in
            self.alert.dismiss(animated: true, completion: nil)
            self.picker.dismiss(animated: true, completion: nil)
        })

        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }

    private func showCamera() {
        self.picker.sourceType = .camera
        self.present.onNext(picker)
    }

    private func showGallery() {
        self.picker.sourceType = .photoLibrary
        self.present.onNext(picker)
    }

    func showPicker() {
        self.present.onNext(alert)
    }

    // MARK: - Delegate implementation

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {

            self.didGetImageURL.onNext(imageURL)
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
