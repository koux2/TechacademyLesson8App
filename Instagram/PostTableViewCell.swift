//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by koux2 on 2021/04/12.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)
        
        // キャプションの表示
        captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        // コメントの表示
        var comments = ""
        for comment in postData.comments {
            comments += "\(comment)\n"
        }
        self.commentLabel.text = comments
        
        // 日時の表示
        dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            dateLabel.text = dateString
        }
        
        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
