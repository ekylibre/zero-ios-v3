//
//  CreateSeedView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CreateSeedView: UIView, UITextFieldDelegate {
  var titleLabel: UILabel!
  var specieLabel: UILabel!
  var specieButton: UIButton!
  var varietyTextField: UITextField!
  var cancelButton: UIButton!
  var createButton: UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)

    titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Création d'une semence"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(titleLabel)

    specieLabel = UILabel(frame: CGRect.zero)
    specieLabel.text = "Espèce"
    specieLabel.font = UIFont.systemFont(ofSize: 15)
    specieLabel.textColor = AppColor.TextColors.DarkGray
    specieLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(specieLabel)

    specieButton = UIButton(frame: CGRect.zero)
    specieButton.setTitle("Avoine", for: .normal)
    specieButton.setTitleColor(UIColor.black, for: .normal)
    specieButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    specieButton.contentHorizontalAlignment = .leading
    specieButton.titleEdgeInsets = UIEdgeInsetsMake(13, 8, 0, 0)
    specieButton.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(specieButton)

    varietyTextField = UITextField(frame: CGRect.zero)
    varietyTextField.placeholder = "Variété"
    varietyTextField.autocorrectionType = .no
    varietyTextField.delegate = self
    varietyTextField.borderStyle = .none
    varietyTextField.layer.backgroundColor = UIColor.white.cgColor
    varietyTextField.layer.masksToBounds = false
    varietyTextField.layer.shadowColor = UIColor.darkGray.cgColor
    varietyTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    varietyTextField.layer.shadowOpacity = 1
    varietyTextField.layer.shadowRadius = 0
    varietyTextField.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(varietyTextField)

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
      "specie" : specieLabel,
      "button" : specieButton,
      "variety" : varietyTextField,
      "cancel" : cancelButton,
      "create" : createButton,
      ] as [String : Any]

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[specie]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[button]-60-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[variety]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[cancel]-15-[create]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[title]-15-[specie][button]-50-[variety]", options: [], metrics: nil, views: viewsDict))
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
    varietyTextField.resignFirstResponder()
    if sender == cancelButton {
      specieButton.setTitle("Avoine", for: .normal)
      varietyTextField.text = ""
    }
    self.isHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
