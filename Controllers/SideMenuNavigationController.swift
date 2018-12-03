//
//  SideMenuNavigationController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 03/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import SideMenu

class SideMenuNavigationController: UISideMenuNavigationController {

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    sideMenuManager.menuPresentMode = .menuSlideIn
    sideMenuManager.menuAnimationFadeStrength = 0.4
  }
}
