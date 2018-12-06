//
//  SelectedInputCell.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

protocol SelectedInputCellDelegate: class {
  func removeInputCell(_ indexPath: IndexPath)
}

class SelectedInputCell: UITableViewCell, UITextFieldDelegate {

  // MARK: - Properties

  weak var cellDelegate: SelectedInputCellDelegate?
  var addInterventionViewController: AddInterventionViewController?
  var indexPath: IndexPath!
  var type = ""

  lazy var inputImageView: UIImageView = {
    let inputImageView = UIImageView(frame: CGRect.zero)
    inputImageView.translatesAutoresizingMaskIntoConstraints = false
    return inputImageView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.systemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var infoLabel: UILabel = {
    let infoLabel = UILabel(frame: CGRect.zero)
    infoLabel.font = UIFont.boldSystemFont(ofSize: 14)
    infoLabel.translatesAutoresizingMaskIntoConstraints = false
    return infoLabel
  }()

  lazy var deleteButton: UIButton = {
    let deleteButton = UIButton(frame: CGRect.zero)
    let tintedImage = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
    deleteButton.setImage(tintedImage, for: .normal)
    deleteButton.tintColor = UIColor.red
    deleteButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    deleteButton.addTarget(self, action: #selector(removeCell), for: .touchUpInside)
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    return deleteButton
  }()

  lazy var quantityLabel: UILabel = {
    let quantityLabel = UILabel(frame: CGRect.zero)
    quantityLabel.text = "quantity".localized
    quantityLabel.textColor = AppColor.TextColors.DarkGray
    quantityLabel.font = UIFont.systemFont(ofSize: 14)
    quantityLabel.translatesAutoresizingMaskIntoConstraints = false
    return quantityLabel
  }()

  lazy var quantityTextField: UITextField = {
    let quantityTextField = UITextField(frame: CGRect.zero)
    quantityTextField.placeholder = "0"
    quantityTextField.keyboardType = .decimalPad
    quantityTextField.textAlignment = .center
    quantityTextField.backgroundColor = AppColor.ThemeColors.White
    quantityTextField.layer.borderWidth = 0.5
    quantityTextField.layer.borderColor = UIColor.lightGray.cgColor
    quantityTextField.layer.cornerRadius = 5
    quantityTextField.clipsToBounds = false
    quantityTextField.delegate = self
    quantityTextField.addTarget(self, action: #selector(saveQuantity), for: .editingChanged)
    quantityTextField.translatesAutoresizingMaskIntoConstraints = false
    return quantityTextField
  }()

  lazy var unitButton: UIButton = {
    let unitButton = UIButton(frame: CGRect.zero)
    unitButton.setTitle("unit", for: .normal)
    unitButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    unitButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    unitButton.backgroundColor = AppColor.ThemeColors.White
    unitButton.layer.borderWidth = 0.5
    unitButton.layer.borderColor = UIColor.lightGray.cgColor
    unitButton.layer.cornerRadius = 5
    unitButton.clipsToBounds = false
    unitButton.addTarget(self, action: #selector(showUnitMeasure), for: .touchUpInside)
    unitButton.translatesAutoresizingMaskIntoConstraints = false
    return unitButton
  }()

  lazy var surfaceQuantity: UILabel = {
    let surfaceQuantity = UILabel(frame: CGRect.zero)
    surfaceQuantity.isHidden = true
    surfaceQuantity.font = UIFont.systemFont(ofSize: 15)
    surfaceQuantity.textColor = AppColor.TextColors.DarkGray
    surfaceQuantity.translatesAutoresizingMaskIntoConstraints = false
    return surfaceQuantity
  }()

  lazy var warningImageView: UIImageView = {
    let warningImageView = UIImageView(frame: CGRect.zero)
    warningImageView.isHidden = true
    warningImageView.image = UIImage(named: "warning")
    warningImageView.tintColor = .red
    warningImageView.translatesAutoresizingMaskIntoConstraints = false
    return warningImageView
  }()

  lazy var warningLabel: UILabel = {
    let warningLabel = UILabel(frame: CGRect.zero)
    warningLabel.isHidden = true
    warningLabel.font = UIFont.systemFont(ofSize: 13)
    warningLabel.textColor = .red
    warningLabel.text = "invalid_dose".localized
    warningLabel.translatesAutoresizingMaskIntoConstraints = false
    return warningLabel
  }()

  lazy var surfaceQuantityTopConstraint: NSLayoutConstraint = {
    let surfaceQuantityTopConstraint = NSLayoutConstraint(
      item: surfaceQuantity,
      attribute: .top,
      relatedBy: .equal,
      toItem: quantityTextField,
      attribute: .bottom,
      multiplier: 1,
      constant: 5)

    surfaceQuantityTopConstraint.isActive = true
    return surfaceQuantityTopConstraint
  }()

  var inputUnit: String!

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    backgroundColor = AppColor.CellColors.LightGray
    selectionStyle = .none
    contentView.addSubview(inputImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(infoLabel)
    contentView.addSubview(deleteButton)
    contentView.addSubview(quantityLabel)
    contentView.addSubview(quantityTextField)
    contentView.addSubview(unitButton)
    contentView.addSubview(warningImageView)
    contentView.addSubview(warningLabel)
    contentView.addSubview(surfaceQuantity)
    contentView.addConstraint(surfaceQuantityTopConstraint)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      inputImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      inputImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      inputImageView.widthAnchor.constraint(equalToConstant: 24),
      inputImageView.heightAnchor.constraint(equalToConstant: 24),
      nameLabel.leadingAnchor.constraint(equalTo: inputImageView.trailingAnchor, constant: 10),
      nameLabel.centerYAnchor.constraint(equalTo: inputImageView.centerYAnchor),
      infoLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
      infoLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor, constant: -10),
      infoLabel.centerYAnchor.constraint(equalTo: inputImageView.centerYAnchor),
      deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
      deleteButton.widthAnchor.constraint(equalToConstant: 40),
      deleteButton.heightAnchor.constraint(equalToConstant: 40),
      quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      quantityLabel.topAnchor.constraint(equalTo: inputImageView.bottomAnchor, constant: 15),
      quantityTextField.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 15),
      quantityTextField.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      quantityTextField.widthAnchor.constraint(equalToConstant: 70),
      quantityTextField.heightAnchor.constraint(equalToConstant: 30),
      unitButton.leadingAnchor.constraint(equalTo: quantityTextField.trailingAnchor, constant: 10),
      unitButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      unitButton.widthAnchor.constraint(equalToConstant: 70),
      unitButton.heightAnchor.constraint(equalToConstant: 30),
      warningImageView.leadingAnchor.constraint(equalTo: quantityTextField.leadingAnchor),
      warningImageView.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 5),
      warningImageView.widthAnchor.constraint(equalToConstant: 10),
      warningImageView.heightAnchor.constraint(equalToConstant: 10),
      warningLabel.leadingAnchor.constraint(equalTo: warningImageView.trailingAnchor, constant: 3),
      warningLabel.centerYAnchor.constraint(equalTo: warningImageView.centerYAnchor),
      surfaceQuantity.leadingAnchor.constraint(equalTo: quantityTextField.leadingAnchor)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Text field

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    guard let oldText = textField.text, let r = Range(range, in: oldText) else {
      return true
    }

    let newText = oldText.replacingCharacters(in: r, with: string)
    var numberOfDecimalDigits = 0

    if newText.components(separatedBy: ".").count > 2 || newText.components(separatedBy: ",").count > 2 {
      return false
    } else if let dotIndex = (newText.contains(",") ? newText.index(of: ",") : newText.index(of: ".")) {
      numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
    }
    return numberOfDecimalDigits <= 2 && newText.count <= 16
  }

  // MARK: - Actions

  private func checkIfUnitContains(unit: String, generalUnits: [String]) -> Bool {
    var contains = false

    for generalUnit in generalUnits {
      if unit.contains(generalUnit) {
        contains = true
      }
    }
    return contains
  }

  private func defineInputsPerSurface(units: [String]) -> [String] {
    var unitsPerSurface = [String]()

    for unit in units {
      let unitPerHectare = unit + "_PER_HECTARE"
      let unitPerSquareMeter = unit + "_PER_SQUARE_METER"

      unitsPerSurface.append(unit)
      unitsPerSurface.append(unitPerHectare)
      unitsPerSurface.append(unitPerSquareMeter)
    }
    return unitsPerSurface
  }

  private func defineInputsUnitsBasedOnCreatedUnit(unit: String) -> [String]? {
    let generalMassUnits = ["GRAM", "KILOGRAM", "QUINTAL", "TON"]
    let generalCountUnits = ["UNITY", "THOUSAND"]
    let generalVolumeUnits = ["LITER", "HECTOLITER", "CUBIC_METER"]

    if checkIfUnitContains(unit: unit, generalUnits: generalMassUnits) {
      return defineInputsPerSurface(units: generalMassUnits)
    } else if checkIfUnitContains(unit: unit, generalUnits: generalCountUnits) {
      return defineInputsPerSurface(units: generalCountUnits)
    } else {
      if checkIfUnitContains(unit: unit, generalUnits: generalVolumeUnits) {
        return defineInputsPerSurface(units: generalVolumeUnits)
      } else {
        return [unit]
      }
    }
  }

  @objc private func showUnitMeasure(sender: UIButton) {
    let units = defineInputsUnitsBasedOnCreatedUnit(unit: inputUnit)

    if units != nil && units!.count > 1 {
      addInterventionViewController?.customPickerView.values = units!
      addInterventionViewController?.customPickerView.pickerView.reloadComponent(0)
      addInterventionViewController?.customPickerView.closure = { (value) in
        self.addInterventionViewController?.selectedInputs[self.indexPath.row].setValue(value, forKey: "unit")
        self.addInterventionViewController?.selectedInputsTableView.reloadData()
      }
      addInterventionViewController?.customPickerView.isHidden = false
    }
  }

  @objc private func removeCell() {
    cellDelegate?.removeInputCell(indexPath)
  }

  private func checkPhytosanitaryDoses(_ phytoID: Int32, _ quantity: Float) -> Bool {
    if let asset = NSDataAsset(name: "phytosanitary-doses") {
      do {
        let jsonResult = try JSONSerialization.jsonObject(with: asset.data)
        let phytosanitaryDoses = jsonResult as? [[String: Any]]

        for phytosanitaryDose in phytosanitaryDoses! {
          let productID = phytosanitaryDose["product_id"] as! NSNumber

          if Int(truncating: productID) == phytoID {
            let dose = phytosanitaryDose["dose"] as! NSNumber

            return quantity <= Float(truncating: dose)
          }
        }
      } catch let error as NSError {
        print("Lexicon fetch failed. \(error)")
      }
    } else {
      print("phytosanitary-doses.json not found")
    }
    return true
  }

  func displayWaringIfInvalidDoses(_ interventionPhyto: InterventionPhytosanitary) {
    let phytoID = interventionPhyto.phyto?.referenceID

    if phytoID != nil && !checkPhytosanitaryDoses(phytoID!, interventionPhyto.quantity) {
      warningLabel.isHidden = false
      warningImageView.isHidden = false
      surfaceQuantityTopConstraint.constant = 20
    } else {
      warningLabel.isHidden = true
      warningImageView.isHidden = true
      surfaceQuantityTopConstraint.constant = 5
    }
  }

  @objc private func saveQuantity() {
    if addInterventionViewController?.selectedInputs[indexPath.row] is InterventionPhytosanitary {
      let phytoID = (addInterventionViewController?.selectedInputs[indexPath.row] as!
        InterventionPhytosanitary).phyto?.referenceID

      if !checkPhytosanitaryDoses(phytoID!, quantityTextField.text!.floatValue) {
        warningLabel.isHidden = false
        warningImageView.isHidden = false
        surfaceQuantityTopConstraint.constant = 20
      } else {
        warningLabel.isHidden = true
        warningImageView.isHidden = true
        surfaceQuantityTopConstraint.constant = 5
      }
    }
    addInterventionViewController?.selectedInputs[indexPath.row].setValue(
      quantityTextField.text!.floatValue, forKey: "quantity")
    addInterventionViewController?.updateQuantityLabel(indexPath: indexPath)
  }
}
