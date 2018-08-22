//
//  CreateFertilizerView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CreateFertilizerView: UIView {
  var titleLabel: UILabel!
  var nameTextField: UITextField!
  var natureLabel: UILabel!
  var cancelButton: UIButton!
  var createButton: UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)

    titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Création d'un fertilisant"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    self.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    nameTextField = UITextField(frame: CGRect.zero)
    nameTextField.placeholder = "Nom"
    nameTextField.autocorrectionType = .no
    nameTextField.borderStyle = .none
    nameTextField.layer.backgroundColor = UIColor.white.cgColor
    nameTextField.layer.masksToBounds = false
    nameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    nameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    nameTextField.layer.shadowOpacity = 1
    nameTextField.layer.shadowRadius = 0
    self.addSubview(nameTextField)
    nameTextField.translatesAutoresizingMaskIntoConstraints = false

    natureLabel = UILabel(frame: CGRect.zero)
    natureLabel.text = "Nature"
    natureLabel.font = UIFont.systemFont(ofSize: 14)
    natureLabel.textColor = AppColor.TextColors.DarkGray
    self.addSubview(natureLabel)
    natureLabel.translatesAutoresizingMaskIntoConstraints = false

    cancelButton = UIButton(frame: CGRect.zero)
    cancelButton.setTitle("ANNULER", for: .normal)
    cancelButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    self.addSubview(cancelButton)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false

    createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("CRÉER", for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    self.addSubview(createButton)
    createButton.translatesAutoresizingMaskIntoConstraints = false

    let viewsDict = [
      "title" : titleLabel,
      "name" : nameTextField,
      "nature" : natureLabel,
      "cancel" : cancelButton,
      "create" : createButton,
      ] as [String : Any]

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[name]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[nature]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[cancel]-15-[create]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[title]-15-[name]-15-[nature]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[cancel]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[create]-15-|", options: [], metrics: nil, views: viewsDict))

    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
  }

  @objc func closeView() {
    nameTextField.resignFirstResponder()
    nameTextField.text = ""
    self.isHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
