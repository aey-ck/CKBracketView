//
//  CKBracketCellTableViewCell.swift
//  CKBracketUsingPanGesture
//
//  Created by Mohammed Shinoys on 7/8/17.
//  Copyright © 2017 Akhil CK. All rights reserved.
//

import UIKit

class CKBracketCell: UITableViewCell {

    @IBOutlet weak var team1: UILabel!
    @IBOutlet weak var team2: UILabel!
    @IBOutlet weak var contianerView: UIView!
    
    @IBOutlet weak var team1Logo: UIImageView!
    @IBOutlet weak var team2Logo: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var team1Score: UILabel!
    @IBOutlet weak var team2Score: UILabel!
   
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        contianerView.dropShadow()
        setUpUi()
        
    }

    
    // MARK: UI set up
    func setUpUi(){
        
        team1Logo.layer.cornerRadius = 12
        team2Logo.layer.cornerRadius = 12

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension UIView {
    
    func dropShadow(scale: Bool = false) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        
    }
}
