//
//  ViewController.swift
//  RealmImageSample
//
//  Created by Tomoya Tanaka on 2022/09/16.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var cameraImageView: UIImageView!
    // 画像加工するためのもととなる画像
    var originalImage: UIImage?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = realm.objects(Image.self).first
        guard let image = image else { return }
        cameraImageView.image = UIImage(data: image.data)
    }

    
    @IBAction func saveImage() {
        // 画像が選択されていなかったらreturnする
        guard let originalImage = originalImage else { return }
        let image = realm.objects(Image.self).first
        // 画像が既に保存されていたら上書きする
        if let image = image {
            // pngDataが取れなかったらreturnする
            guard let data = originalImage.pngData() else { return }
            try! realm.write {
                image.data = data
            }
            print("保存できました!")
        } else {
            // 画像が保存されていなかったら新規作成して保存する
           let image = Image()
            // pngDataが取れなかったらreturnする
            guard let data = originalImage.pngData() else { return }
            image.data = data
            try! realm.write {
                realm.add(image)
            }
            print("保存できました!")
        }
    }

    @IBAction func selectImage() {
        // カメラロールを使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            // カメラロールの画像を選択して画像を表示するまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    // カメラロールの画像が選択された時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraImageView.image = info[.editedImage] as? UIImage
        
        originalImage = cameraImageView.image

        dismiss(animated: true, completion: nil)
    }
    
    
}

