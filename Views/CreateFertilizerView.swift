//
//  CreateFertilizerView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CreateFertilizerView: UIView, UITextFieldDelegate {
  var titleLabel: UILabel!
  var nameTextField: UITextField!
  var natureLabel: UILabel!
  var natureButton: UIButton!
  var natureAlertController: UIAlertController!
  var cancelButton: UIButton!
  var createButton: UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)

    titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Création d'un fertilisant"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(titleLabel)

    nameTextField = UITextField(frame: CGRect.zero)
    nameTextField.placeholder = "Nom"
    nameTextField.autocorrectionType = .no
    nameTextField.delegate = self
    nameTextField.borderStyle = .none
    nameTextField.layer.backgroundColor = UIColor.white.cgColor
    nameTextField.layer.masksToBounds = false
    nameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    nameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    nameTextField.layer.shadowOpacity = 1
    nameTextField.layer.shadowRadius = 0
    nameTextField.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(nameTextField)

    natureLabel = UILabel(frame: CGRect.zero)
    natureLabel.text = "Nature"
    natureLabel.font = UIFont.systemFont(ofSize: 14)
    natureLabel.textColor = AppColor.TextColors.DarkGray
    natureLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(natureLabel)

    natureButton = UIButton(frame: CGRect.zero)
    natureButton.setTitle("Organique", for: .normal)
    natureButton.setTitleColor(UIColor.black, for: .normal)
    natureButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    natureButton.contentHorizontalAlignment = .leading
    natureButton.titleEdgeInsets = UIEdgeInsetsMake(13, 8, 0, 0)
    //natureButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    natureButton.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(natureButton)

    natureAlertController = UIAlertController(title: "Choisissez une nature", message: nil, preferredStyle: .actionSheet)
    natureAlertController.addAction(UIAlertAction(title: "Organique", style: .default, handler: { action in
      self.natureButton.setTitle("Organique", for: .normal)
      }))
    natureAlertController.addAction(UIAlertAction(title: "Minéral", style: .default, handler: { action in
      self.natureButton.setTitle("Minéral", for: .normal)
    }))
    natureAlertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))

    cancelButton = UIButton(frame: CGRect.zero)
    cancelButton.setTitle("ANNULER", for: .normal)
    cancelButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(cancelButton)

    createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("CRÉER", for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(createButton)

    let viewsDict = [
      "title" : titleLabel,
      "name" : nameTextField,
      "nature" : natureLabel,
      "button" : natureButton,
      "cancel" : cancelButton,
      "create" : createButton,
      ] as [String : Any]

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[name]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[nature]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[button]-60-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[cancel]-15-[create]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[title]-35-[name]-25-[nature][button]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[cancel]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[create]-15-|", options: [], metrics: nil, views: viewsDict))

    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  @objc func closeView(sender: UIButton) {
    nameTextField.resignFirstResponder()
    if sender == cancelButton {
      nameTextField.text = ""
      natureButton.setTitle("Organique", for: .normal)
    }
    self.isHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
