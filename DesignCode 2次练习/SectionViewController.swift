//
//  SectionViewController.swift
//  DesignCode 2次练习
//
//  Created by 孙红艳 on 2019/08/16.
//  Copyright © 2019 孙红艳. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var coveImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    var section:[String:String]!
    var sections: [[String: String]]!
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = section["title"]
        captionLabel.text = section["caption"]
        bodyLabel.text = section["body"]
        coveImageView.image = UIImage(named:section["image"]!)
        progressLabel.text = "\(indexPath.row+1) / \(sections.count)"
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
    }
}
    

