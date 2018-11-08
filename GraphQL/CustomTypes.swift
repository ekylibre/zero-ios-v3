//
//  CustomTypes.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 06/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Apollo
import MapKit

extension Date: JSONDecodable, JSONEncodable {
  public init(jsonValue value: JSONValue) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = string.count > 10 ? "yyyy-MM-dd HH:mm:ss zzz" : "yyyy-MM-dd"

    guard let date = dateFormatter.date(from: string) else {
      throw JSONDecodingError.couldNotConvert(value: string, to: Date.self)
    }

    self = date
  }

  public var jsonValue: JSONValue {
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: self)
  }
}

public typealias Point = MKMapPoint

extension Point: JSONDecodable, JSONEncodable {
  public init(jsonValue value: JSONValue) throws {
    guard let coordinates = value as? [Double] else {
      throw JSONDecodingError.couldNotConvert(value: value, to: [Double].self)
    }

    guard let longitude = coordinates.first, let latitude = coordinates.last else {
      throw JSONDecodingError.couldNotConvert(value: coordinates, to: Double.self)
    }
    self = Point(x: longitude, y: latitude)
  }

  public var jsonValue: JSONValue {
    return String(format: "[%@,%@]", String(self.x), String(self.y))
  }
}
