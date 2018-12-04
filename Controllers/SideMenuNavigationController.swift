//
//  SideMenuNavigationController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 03/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import SideMenu

class SideMenuNavigationController: UISideMenuNavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let screenRect = UIScreen.main.bounds

    sideMenuManager.menuWidth = max(round(min((screenRect.width), (screenRect.height)) * 0.75), 250)
    sideMenuManager.menuPresentMode = .menuSlideIn
    sideMenuManager.menuAnimationFadeStrength = 0.4
  }
}
