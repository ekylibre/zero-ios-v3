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
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"

    guard let date = dateFormatter.date(from: string) else {
      throw JSONDecodingError.couldNotConvert(value: string, to: Date.self)
    }

    self = date
  }

  public var jsonValue: JSONValue {
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
    return dateFormatter.string(from: self)
  }
}

public typealias Point = MKMapPoint
public typealias Polygon = MKPolygon

extension Point: JSONDecodable, JSONEncodable {
  public init(jsonValue value: JSONValue) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }

    let coordinates = string[1 ... string.count - 1].split(separator: ",")

    guard let longitude = Double(coordinates[1]), let latitude = Double(coordinates[0]) else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }
    self = Point(x: longitude, y: latitude)
  }

  public var jsonValue: JSONValue {
    return String(format: "[%@,%@]", String(self.x), String(self.y))
  }
}

extension MKPolygon: JSONDecodable {
  init(jsonValue value: JSONValue) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }

    let points = string[3 ... string.count - 3].split(separator: ",")
    var lngLats = [Point]()

    for point in points {
      let lngLat = point.split(separator: ",")
      lngLats.append(Point(x: Double(lngLat[1])!, y: Double(lngLat[0])!))
    }
    return Polygon(points: lngLats, count: lngLats.count)
  }
}

  /*public var jsonValue: JSONValue {
    let points = self.points()
    let string = "["

    for case let point as Point in points {
      string.append("[")
      string.appendingFormat("[%s,%s]", point.x, point.y)
    }
    string.append("]")
  }
}*/
