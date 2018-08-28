//
//  CropsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 27/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CropsView: UIView, UITableViewDataSource, UITableViewDelegate {

  //MARK: - Properties

  var headerView: UIView {
    let headerView = UIView(frame: CGRect.zero)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    headerView.backgroundColor = AppColor.BarColors.Green
    self.addSubview(headerView)
    return headerView
  }

  var titleLabel: UILabel {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = "Sélectionnez des cultures"
    headerView.addSubview(titleLabel)
    return titleLabel
  }

  var tableView: UITableView {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorInset = UIEdgeInsets.zero
    tableView.tableFooterView = UIView()
    tableView.bounces = false
    tableView.register(SeedsTableViewCell.self, forCellReuseIdentifier: "CropsCell")
    tableView.delegate = self
    tableView.dataSource = self
    self.addSubview(tableView)
    return tableView
  }

  var bottomView: UIView {
    let bottomView = UIView(frame: CGRect.zero)
    bottomView.translatesAutoresizingMaskIntoConstraints = false
    bottomView.backgroundColor = AppColor.BarColors.Green
    self.addSubview(bottomView)
    return bottomView
  }

  var selectedCropsLabel: UILabel {
    let selectedCropsLabel = UILabel(frame: CGRect.zero)
    selectedCropsLabel.text = "Aucune sélection"
    selectedCropsLabel.translatesAutoresizingMaskIntoConstraints = false
    bottomView.addSubview(selectedCropsLabel)
    return selectedCropsLabel
  }

  var validateButton: UIButton {
    let validateButton = UIButton(frame: CGRect.zero)
    validateButton.setTitle("VALIDER", for: .normal)
    validateButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    validateButton.backgroundColor = UIColor.black
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    validateButton.translatesAutoresizingMaskIntoConstraints = false
    bottomView.addSubview(validateButton)
    return validateButton
  }

  //MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.isHidden = true
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }

  //MARK: - Table view

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CropCell", for: indexPath) as! CropTableViewCell

    return cell
  }

  //MARK: - Actions
}
