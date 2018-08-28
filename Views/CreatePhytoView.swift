//
//  CreatePhytoView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CreatePhytoView: UIView, UITextFieldDelegate {

  //MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Création d'un produit phyto"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var nameTextField: UITextField = {
    let nameTextField = UITextField(frame: CGRect.zero)
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
    nameTextField.translatesAutoresizingMaskIntoConstraints = false
    return nameTextField
  }()

  lazy var firmNameTextField: UITextField = {
    let firmNameTextField = UITextField(frame: CGRect.zero)
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
    firmNameTextField.translatesAutoresizingMaskIntoConstraints = false
    return firmNameTextField
  }()

  lazy var maaTextField: UITextField = {
    let maaTextField = UITextField(frame: CGRect.zero)
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
    maaTextField.translatesAutoresizingMaskIntoConstraints = false
    return maaTextField
  }()

  lazy var reentryDelayTextField: UITextField = {
    let reentryDelayTextField = UITextField(frame: CGRect.zero)
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
    reentryDelayTextField.translatesAutoresizingMaskIntoConstraints = false
    return reentryDelayTextField
  }()

  lazy var unitLabel: UILabel = {
    let unitLabel = UILabel(frame: CGRect.zero)
    unitLabel.text = "en heures"
    unitLabel.font = UIFont.systemFont(ofSize: 14)
    unitLabel.textColor = UIColor.lightGray
    unitLabel.translatesAutoresizingMaskIntoConstraints = false
    return unitLabel
  }()

  lazy var cancelButton: UIButton = {
    let cancelButton = UIButton(frame: CGRect.zero)
    cancelButton.setTitle("ANNULER", for: .normal)
    cancelButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    return cancelButton
  }()

  lazy var createButton: UIButton = {
    let createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("CRÉER", for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    return createButton
  }()

  //MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
    self.addSubview(titleLabel)
    self.addSubview(nameTextField)
    self.addSubview(firmNameTextField)
    self.addSubview(maaTextField)
    self.addSubview(reentryDelayTextField)
    self.addSubview(unitLabel)
    self.addSubview(cancelButton)
    self.addSubview(createButton)
    setupLayout()
    setupActions()
  }

  private func setupLayout() {
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
  }

  private func setupActions() {
    cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    createButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Text field

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextTag = textField.tag + 1

    if let nextResponder = textField.superview?.viewWithTag(nextTag) as? UITextField {
      nextResponder.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }

    return false
  }

  //MARK: - Actions

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
}
