//
//  IncomingImageMessageCell.swift
//  Nyelam
//
//  Created by Bobi on 9/18/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SimpleImageViewer

class IncomingImageMessageCell: NTableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var container: UIView!
    
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.container.layer.borderWidth = 1
        self.container.layer.borderColor = UIColor.lightGray.cgColor

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func imageShowButtonAction(_ sender: Any) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = messageImageView
        }
        let imageViewerController = ImageViewerController(configuration: configuration)
        self.viewController!.present(imageViewerController, animated: true, completion: {})
    }
}
