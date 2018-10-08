
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
    let cropImageView = UIImageView(frame: CGRect.zero)
    let cropImage = #imageLiteral(resourceName: "crop")
    let tintedImage = cropImage.withRenderingMode(.alwaysTemplate)
    cropImageView.image = tintedImage
    cropImageView.tintColor = UIColor.darkGray
    cropImageView.backgroundColor = UIColor.lightGray
    cropImageView.translatesAutoresizingMaskIntoConstraints = false
    return cropImageView
  }()

  lazy var checkboxImage: UIImageView = {
    let checkboxImage = UIImageView(frame: CGRect.zero)
    checkboxImage.image = #imageLiteral(resourceName: "check-box-blank")
    checkboxImage.translatesAutoresizingMaskIntoConstraints = false
    return checkboxImage
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    let calendar = Calendar.current
    let year = calendar.component(.year, from: crop.startDate!)
    nameLabel.textColor = UIColor.black
    nameLabel.text = crop.species! + " | \(year)"
    nameLabel.font = UIFont.systemFont(ofSize: 13.0)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var surfaceAreaLabel: UILabel = {
    let surfaceAreaLabel = UILabel(frame: CGRect.zero)
    surfaceAreaLabel.textColor = UIColor.darkGray
    surfaceAreaLabel.text = String(format: "%.1f ha travaillés", crop.surfaceArea)
    surfaceAreaLabel.font = UIFont.systemFont(ofSize: 13.0)
    surfaceAreaLabel.translatesAutoresizingMaskIntoConstraints = false
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
    self.addSubview(checkboxImage)
    self.addSubview(nameLabel)
    self.addSubview(surfaceAreaLabel)
    self.addGestureRecognizer(gesture)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      cropImageView.topAnchor.constraint(equalTo: self.topAnchor),
      cropImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
      cropImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
      cropImageView.widthAnchor.constraint(equalTo: self.heightAnchor),
      checkboxImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      checkboxImage.heightAnchor.constraint(equalToConstant: 20),
      checkboxImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
      checkboxImage.widthAnchor.constraint(equalToConstant: 20),
      nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      nameLabel.leftAnchor.constraint(equalTo: cropImageView.rightAnchor, constant: 10),
      nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
      surfaceAreaLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      surfaceAreaLabel.leftAnchor.constraint(equalTo: cropImageView.rightAnchor, constant: 10),
      surfaceAreaLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
