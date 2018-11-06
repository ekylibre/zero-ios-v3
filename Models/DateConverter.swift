//
//  Date.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 06/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class DateConverter {
  class func convertDateStringInLocalizedFormat(_ date: Date!) -> String {
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "date_format".localized
    return dateFormatter.string(from: date!)
  }
}
