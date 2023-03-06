//
//  ImageView.swift
//  Logger
//
//  Created by Andres Marquez on 2023-03-04.
//

import UIKit

class ImageView: UIImageView {

    private let imageView: UIImageView = {
        let image = UIImage(systemName: "pencil.and.outline")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = frame
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
