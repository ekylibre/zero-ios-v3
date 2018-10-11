//
//  CropView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 13/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CropView: UIView {

  // MARK: - Properties

  lazy var cropImageView: UIImageView = {
    let cropImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    let cropImage = UIImage(named: "plots")!
    let tintedImage = cropImage.withRenderingMode(.alwaysTemplate)
    cropImageView.image = tintedImage
    cropImageView.tintColor = UIColor.darkGray
    cropImageView.backgroundColor = UIColor.lightGray
    return cropImageView
  }()

  lazy var checkboxImageView: UIImageView = {
    let checkboxImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
    checkboxImageView.image = UIImage(named: "check-box-blank")
    return checkboxImageView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect(x: 70, y: 7, width: 200, height: 20))
    let calendar = Calendar.current
    let year = calendar.component(.year, from: crop.startDate!)
    nameLabel.textColor = UIColor.black
    nameLabel.text = crop.name! + " | \(year)"
    nameLabel.font = UIFont.systemFont(ofSize: 13.0)
    return nameLabel
  }()

  lazy var surfaceAreaLabel: UILabel = {
    let surfaceAreaLabel = UILabel(frame: CGRect(x: 70, y: 33, width: 200, height: 20))
    surfaceAreaLabel.textColor = UIColor.darkGray
    surfaceAreaLabel.text = String(format: "%.1f ha travaillés", crop.surfaceArea)
    surfaceAreaLabel.font = UIFont.systemFont(ofSize: 13.0)
    return surfaceAreaLabel
  }()

  lazy var gesture: UITapGestureRecognizer = {
    let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    gesture.numberOfTapsRequired = 1
    return gesture
  }()

  let crop: Crops

  // MARK: - Initialization

  init(frame: CGRect, _ crop: Crops) {
    self.crop = crop
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.backgroundColor = UIColor.white
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 0.5
    self.addSubview(cropImageView)
    self.addSubview(checkboxImageView)
    self.addSubview(nameLabel)
    self.addSubview(surfaceAreaLabel)
    self.addGestureRecognizer(gesture)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
