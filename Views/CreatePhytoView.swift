//
//  CreatePhytoView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CreatePhytoView: UIView, UITextFieldDelegate {
  var titleLabel: UILabel!
  var nameTextField: UITextField!
  var firmNameTextField: UITextField!
  var maaTextField: UITextField!
  var reentryDelayTextField: UITextField!
  var unitLabel: UILabel!
  var cancelButton: UIButton!
  var createButton: UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)

    titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Création d'un produit phyto"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    self.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    nameTextField = UITextField(frame: CGRect.zero)
    nameTextField.placeholder = "Nom"
    nameTextField.autocorrectionType = .no
    nameTextField.delegate = self
    nameTextField.tag = 10
    nameTextField.borderStyle = .none
    nameTextField.layer.backgroundColor = UIColor.white.cgColor
    nameTextField.layer.masksToBounds = false
    nameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    nameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    nameTextField.layer.shadowOpacity = 1
    nameTextField.layer.shadowRadius = 0
    self.addSubview(nameTextField)
    nameTextField.translatesAutoresizingMaskIntoConstraints = false

    firmNameTextField = UITextField(frame: CGRect.zero)
    firmNameTextField.placeholder = "Marque"
    firmNameTextField.autocorrectionType = .no
    firmNameTextField.delegate = self
    firmNameTextField.tag = 11
    firmNameTextField.borderStyle = .none
    firmNameTextField.layer.backgroundColor = UIColor.white.cgColor
    firmNameTextField.layer.masksToBounds = false
    firmNameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    firmNameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    firmNameTextField.layer.shadowOpacity = 1
    firmNameTextField.layer.shadowRadius = 0
    self.addSubview(firmNameTextField)
    firmNameTextField.translatesAutoresizingMaskIntoConstraints = false

    maaTextField = UITextField(frame: CGRect.zero)
    maaTextField.keyboardType = .numberPad
    maaTextField.placeholder = "N° AMM"
    maaTextField.autocorrectionType = .no
    maaTextField.delegate = self
    maaTextField.tag = 12
    maaTextField.borderStyle = .none
    maaTextField.layer.backgroundColor = UIColor.white.cgColor
    maaTextField.layer.masksToBounds = false
    maaTextField.layer.shadowColor = UIColor.darkGray.cgColor
    maaTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    maaTextField.layer.shadowOpacity = 1
    maaTextField.layer.shadowRadius = 0
    self.addSubview(maaTextField)
    maaTextField.translatesAutoresizingMaskIntoConstraints = false

    reentryDelayTextField = UITextField(frame: CGRect.zero)
    reentryDelayTextField.keyboardType = .numberPad
    reentryDelayTextField.placeholder = "Délai de ré-entrée"
    reentryDelayTextField.autocorrectionType = .no
    reentryDelayTextField.delegate = self
    reentryDelayTextField.tag = 13
    reentryDelayTextField.borderStyle = .none
    reentryDelayTextField.layer.backgroundColor = UIColor.white.cgColor
    reentryDelayTextField.layer.masksToBounds = false
    reentryDelayTextField.layer.shadowColor = UIColor.darkGray.cgColor
    reentryDelayTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    reentryDelayTextField.layer.shadowOpacity = 1
    reentryDelayTextField.layer.shadowRadius = 0
    self.addSubview(reentryDelayTextField)
    reentryDelayTextField.translatesAutoresizingMaskIntoConstraints = false

    unitLabel = UILabel(frame: CGRect.zero)
    unitLabel.text = "en heures"
    unitLabel.font = UIFont.systemFont(ofSize: 14)
    unitLabel.textColor = UIColor.lightGray
    self.addSubview(unitLabel)
    unitLabel.translatesAutoresizingMaskIntoConstraints = false

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
      "firm" : firmNameTextField,
      "maa" : maaTextField,
      "reentry" : reentryDelayTextField,
      "unit" : unitLabel,
      "cancel" : cancelButton,
      "create" : createButton,
      ] as [String : Any]

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[name]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[firm]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[maa]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[reentry]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[unit]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[cancel]-15-[create]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[title]-30-[name]-35-[firm]-35-[maa]-35-[reentry]-5-[unit]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[cancel]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[create]-15-|", options: [], metrics: nil, views: viewsDict))

    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextTag = textField.tag + 1

    if let nextResponder = textField.superview?.viewWithTag(nextTag) as? UITextField {
      nextResponder.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }

    return false
  }

  @objc func closeView(sender: UIButton) {
    for subview in self.subviews {
      if sender == cancelButton && subview is UITextField {
        let textField = subview as! UITextField
        textField.resignFirstResponder()
        textField.text = ""
      }
    }
    self.isHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
