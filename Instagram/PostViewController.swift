//
//  PostViewController.swift
//  Instagram
//
//  Created by koux2 on 2021/04/05.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    // 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換
        let imageData = image.jpegData(compressionQuality: 0.75)
        // 画像と投稿データの保存場所を定義する
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        
        SVProgressHUD.show()
        
        // Storageに画像をアップロード
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像アップロードに失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 投稿処理をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            
            // FIreStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp()
            ] as [String: Any]
            postRef.setData(postDic)
            
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            
            // 投稿処理が完了したので先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            
        }
    }
    
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
}
