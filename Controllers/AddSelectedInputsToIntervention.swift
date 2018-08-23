//
//  AddSelectedInputsToIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 23/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {
  func changeInputsViewAndTableViewSize() {
    inputsHeightConstraint.constant = self.inputsSelection.tableView.contentSize.height + 100
    NSLayoutConstraint(item: inputsSelection.tableView, attribute: .bottom, relatedBy: .equal, toItem: inputsSelectionView, attribute: .bottom, multiplier: 1, constant: -30).isActive = true
  }

  func closeSelectInputsView() {
    dimView.isHidden = true
    inputsView.isHidden = true

    if selectedInputs.count > 0 {
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
        self.view.layoutIfNeeded()
        self.inputsCollapseButton.isHidden = false
        self.selectedInputsTableView.isHidden = false
        self.changeInputsViewAndTableViewSize()
        self.inputsCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
      })
    }
    inputsSelection.reloadTable()
    inputsSelection.tableView.reloadData()
    selectedInputsTableView.reloadData()
  }

  func showInputsNumber() {
    if selectedInputs.count > 0 && inputsHeightConstraint.constant == 70 {
      addInputsButton.isHidden = true
      inputsNumber.text = (selectedInputs.count == 1 ? "1 intrant" : "\(selectedInputs.count) intrants")
      inputsNumber.isHidden = false
    } else {
      inputsNumber.isHidden = true
      addInputsButton.isHidden = false
    }
  }

  @IBAction func collapseInputsView(_ sender: Any) {
    if inputsHeightConstraint.constant != 70 {
      UIView.animate(withDuration: 0.5, animations: {
        self.selectedInputsTableView.isHidden = true
        self.inputsHeightConstraint.constant = 70
        self.inputsCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.view.layoutIfNeeded()
      })
    } else {
      UIView.animate(withDuration: 0.5, animations: {
      self.selectedInputsTableView.isHidden = false
      self.changeInputsViewAndTableViewSize()
      self.inputsCollapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
      self.view.layoutIfNeeded()
    })
    }
    showInputsNumber()
  }
}
