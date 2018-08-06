//
//  RoundedButton.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class roundedButton: UIButton {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    layer.cornerRadius = 5
    layer.backgroundColor = UIColor(red: 214/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1.0).cgColor
    layer.masksToBounds = false
    layer.shadowRadius = 1
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0.6
    contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
  }
}
