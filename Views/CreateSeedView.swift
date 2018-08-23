//
//  CreateSeedView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import DropDown

class CreateSeedView: UIView, UITextFieldDelegate {
  var titleLabel: UILabel!
  var specieLabel: UILabel!
  var specieButton: UIButton!
  var specieDropDown: DropDown!
  var varietyTextField: UITextField!
  var cancelButton: UIButton!
  var createButton: UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)

    titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Création d'une semence"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    self.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    specieLabel = UILabel(frame: CGRect.zero)
    specieLabel.text = "Espèce"
    specieLabel.font = UIFont.systemFont(ofSize: 15)
    specieLabel.textColor = AppColor.TextColors.DarkGray
    self.addSubview(specieLabel)
    specieLabel.translatesAutoresizingMaskIntoConstraints = false

    specieButton = UIButton(frame: CGRect.zero)
    specieButton.setTitle("Avoine", for: .normal)
    specieButton.setTitleColor(UIColor.black, for: .normal)
    specieButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    specieButton.contentHorizontalAlignment = .leading
    specieButton.titleEdgeInsets = UIEdgeInsetsMake(13, 8, 0, 0)
    specieButton.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
    self.addSubview(specieButton)
    specieButton.translatesAutoresizingMaskIntoConstraints = false

    specieDropDown = DropDown(anchorView: specieButton)
    specieDropDown.dataSource = ["Avoine", "Blé dur", "Blé tendre", "Maïs", "Riz", "Triticale", "Soja", "Tournesol annuel", "Fève ou féverole", "Luzerne", "Pois commun", "Sainfoin", "Chanvre"]
    specieDropDown.direction = .bottom
    specieDropDown.selectionAction = { [weak self] (index, item) in
      self?.specieButton.setTitle(item, for: .normal)
    }

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
    self.addSubview(varietyTextField)
    varietyTextField.translatesAutoresizingMaskIntoConstraints = false

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

  @objc func showDropDown() {
    specieDropDown.show()
  }

  @objc func closeView(sender: UIButton) {
    varietyTextField.resignFirstResponder()
    if sender == cancelButton {
      specieButton.setTitle("Avoine", for: .normal)
      varietyTextField.text = ""
    }
    let index = specieDropDown.indexForSelectedRow
    specieDropDown.deselectRow(at: index)
    self.isHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
