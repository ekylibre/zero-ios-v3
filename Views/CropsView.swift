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

  public var titleLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "Sélectionnez des cultures"
    label.font = UIFont.systemFont(ofSize: 19)
    label.textColor = AppColor.TextColors.White
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var headerView: UIView = {
    let view = UIView(frame: CGRect.zero)
    view.backgroundColor = AppColor.BarColors.Green
    view.addSubview(titleLabel)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  var selectedIndexPath: IndexPath?
  var indexPaths: [IndexPath] = []

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.separatorInset = UIEdgeInsets.zero
    tableView.tableFooterView = UIView()
    tableView.bounces = false
    tableView.register(SeedCell.self, forCellReuseIdentifier: "SeedCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44
    return tableView
  }()

  public var selectedCropsLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "Aucune sélection"
    label.font = UIFont.systemFont(ofSize: 17)
    label.textColor = AppColor.TextColors.White
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  public var validateButton: UIButton = {
    let button = UIButton(frame: CGRect.zero)
    button.setTitle("VALIDER", for: .normal)
    button.setTitleColor(AppColor.TextColors.Black, for: .normal)
    button.backgroundColor = UIColor.white
    button.layer.cornerRadius = 5
    button.clipsToBounds = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  lazy var bottomView: UIView = {
    let view = UIView(frame: CGRect.zero)
    view.backgroundColor = AppColor.BarColors.Green
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(selectedCropsLabel)
    view.addSubview(validateButton)
    return view
  }()

  //MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    //self.translatesAutoresizingMaskIntoConstraints = false
    self.isHidden = true
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.addSubview(headerView)
    self.addSubview(tableView)
    self.addSubview(bottomView)
    setupLayout()
  }

  private func setupLayout() {
    let viewsDict = [
      "header" : headerView,
      "title" : titleLabel,
      "table" : tableView,
      "bottom" : bottomView,
      "selected" : selectedCropsLabel,
      "validate" : validateButton,
      ] as [String : Any]

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]", options: [], metrics: nil, views: viewsDict))
    NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[selected]", options: [], metrics: nil, views: viewsDict))
    NSLayoutConstraint(item: selectedCropsLabel, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[validate(>=90)]-13-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-13-[validate]-13-|", options: [], metrics: nil, views: viewsDict))

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[header]|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottom]|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[header(60)][table][bottom(60)]|", options: [], metrics: nil, views: viewsDict))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Table view

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SeedCell", for: indexPath) as! SeedCell

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndexPath = indexPath

    let cell = tableView.cellForRow(at: selectedIndexPath!) as! CropCell
    if !indexPaths.contains(selectedIndexPath!) {
      indexPaths += [selectedIndexPath!]
      cell.expandCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    } else {
      let index = indexPaths.index(of: selectedIndexPath!)
      indexPaths.remove(at: index!)
      cell.expandCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPaths.contains(indexPath) {
      guard let cell = tableView.cellForRow(at: indexPath) else {
        return 0
      }
      let count = cell.subviews.count - 2
      return CGFloat(count * 60 + 15)
    } else {
      return 60
    }
  }

  //MARK: - Actions
}
