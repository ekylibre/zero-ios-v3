//
//  SelectDateView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SelectDateView: UIView {

  // MARK: - Properties

  var dialogView: UIView!

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 280, height: 30))
    titleLabel.text = "This is a test"
    titleLabel.font = UIFont.systemFont(ofSize: 17)
    titleLabel.textAlignment = .center
    return titleLabel
  }()

  lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 30, width: 300, height: 216))
    datePicker.autoresizingMask = .flexibleRightMargin
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "locale".localized)
    return datePicker
  }()

  lazy var cancelButton: UIButton = {
    let cancelButton = UIButton(frame: CGRect.zero)
    cancelButton.backgroundColor = UIColor.white
    cancelButton.setTitle("cancel".localized, for: .normal)
    cancelButton.setTitleColor(AppColor.TextColors.Blue, for: .normal)
    cancelButton.setTitleColor(AppColor.TextColors.LightBlue, for: .highlighted)
    return cancelButton
  }()

  lazy var doneButton: UIButton = {
    let doneButton = UIButton(frame: CGRect.zero)
    doneButton.backgroundColor = UIColor.white
    doneButton.setTitle("done".localized, for: .normal)
    doneButton.setTitleColor(AppColor.TextColors.Blue, for: .normal)
    doneButton.setTitleColor(AppColor.TextColors.LightBlue, for: .highlighted)
    return doneButton
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    dialogView = createContainerView()
    dialogView.layer.shouldRasterize = true
    dialogView.layer.rasterizationScale = UIScreen.main.scale
    dialogView.layer.opacity = 0.5
    dialogView.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    backgroundColor = UIColor.clear
    addSubview(dialogView)
  }

  private func createContainerView() -> UIView {
    let screenSize = UIScreen.main.bounds.size
    let containerFrame = CGRect(x: (screenSize.width - 300) / 2, y: (screenSize.height - 281) / 2, width: 300, height: 281)
    let container = UIView(frame: containerFrame)
    let gradient = CAGradientLayer(layer: layer)

    frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    gradient.frame = container.bounds
    gradient.colors = [UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor,
                       UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1).cgColor,
                       UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor]
    gradient.cornerRadius = 7
    container.layer.insertSublayer(gradient, at: 0)
    container.layer.cornerRadius = 7
    container.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
    container.layer.borderWidth = 1
    container.layer.shadowRadius = 12
    container.layer.shadowOpacity = 0.1
    container.layer.shadowOffset = CGSize(width: -6, height: -6)
    container.layer.shadowColor = UIColor.black.cgColor
    container.layer.shadowPath =
      UIBezierPath(roundedRect: container.bounds, cornerRadius: container.layer.cornerRadius).cgPath
    container.clipsToBounds = true

    let yPosition = container.bounds.size.height - 51
    let lineView = UIView(frame: CGRect(x: 0, y: yPosition, width: container.bounds.size.width, height: 1))

    lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
    container.addSubview(lineView)
    container.addSubview(titleLabel)
    container.addSubview(datePicker)
    addButtonsToView(container: container)
    return container
  }

  private func addButtonsToView(container: UIView) {
    let buttonWidth = container.bounds.size.width / 2
    let leftButtonFrame = CGRect(x: 0, y: container.bounds.size.height - 50, width: buttonWidth, height: 50)
    let rightButtonFrame = CGRect(x: buttonWidth, y: container.bounds.size.height - 50, width: buttonWidth, height: 50)

    cancelButton.frame = leftButtonFrame
    doneButton.frame = rightButtonFrame
    container.addSubview(cancelButton)
    container.addSubview(doneButton)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Display

  func show() {
    guard let appDelegate = UIApplication.shared.delegate else { return }
    guard let window = appDelegate.window else { return }

    window?.endEditing(true)
    window?.addSubview(self)
    window?.bringSubviewToFront(self)

    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
      self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
      self.dialogView.layer.opacity = 1
      self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1)
    })
  }

  func close() {
    let currentTransform = self.dialogView.layer.transform
    let startRotation = (self.value(forKeyPath: "layer.transform.rotation.z") as? NSNumber) as? Double ?? 0.0
    let rotation = CATransform3DMakeRotation((CGFloat)(-startRotation + .pi * 270 / 180), 0, 0, 0)

    dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
    dialogView.layer.opacity = 1

    UIView.animate(withDuration: 0.2, animations: {
        self.backgroundColor = UIColor.clear
        self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
        self.dialogView.layer.opacity = 0
    }) { (_) in
      for subview in self.subviews {
        subview.removeFromSuperview()
      }

      self.removeFromSuperview()
      self.setupView()
    }
  }
}
