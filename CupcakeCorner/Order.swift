//
//  Order.swift
//  CupcakeCorner
//
//  Created by Дмитрий Геращенко on 16.07.2021.
//

import Foundation

final class Order: ObservableObject, Codable {
  
  enum CodingKeys: CodingKey {
    case type, quantity, extraFrosting, addSprinkles,
         name, streetAdress, city, zip
  }
  
  static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
  
  @Published var type = 0
  @Published var quantity = 3
  
  @Published var specialRequestEnabled = false {
    didSet {
      if specialRequestEnabled == false {
        extraFrosting = false
        addSprinkles = false
      }
    }
  }
  @Published var extraFrosting = false
  @Published var addSprinkles = false
  
  @Published var name = ""
  @Published var streetAdress = ""
  @Published var city = ""
  @Published var zip = ""
  
  private func spaceValidation(for string: String) -> Bool {
    if string == " " ||
        string.count < 2 ||
        string.isEmpty ||
        ((string + " ").hasPrefix(" ") || (string + " ").hasSuffix(" "))
    {
      return false
    }
    return true
  }
  
  var hasValidAddress: Bool {
    
    if spaceValidation(for: name) ||
        spaceValidation(for: streetAdress) ||
        spaceValidation(for: city) ||
        spaceValidation(for: zip)
    {
      return false
    }
    
    return true
  }
  
  var cost: Double {
    var cost = Double(quantity) * 2
    cost += Double(type) / 2
    
    if addSprinkles {
      cost += Double(quantity) / 2
    }
    
    if extraFrosting {
      cost += Double(quantity)
    }
    
    return cost
  }
  
  init() {
    
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    type = try container.decode(Int.self, forKey: .type)
    quantity = try container.decode(Int.self, forKey: .quantity)
    addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
    extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
    
    name = try container.decode(String.self, forKey: .name)
    streetAdress = try container.decode(String.self, forKey: .streetAdress)
    city = try container.decode(String.self, forKey: .city)
    zip = try container.decode(String.self, forKey: .zip)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(type, forKey: .type)
    try container.encode(quantity, forKey: .quantity)
    try container.encode(extraFrosting, forKey: .extraFrosting)
    try container.encode(addSprinkles, forKey: .addSprinkles)
    
    try container.encode(name, forKey: .name)
    try container.encode(streetAdress, forKey: .streetAdress)
    try container.encode(city, forKey: .city)
    try container.encode(zip, forKey: .zip)
  }
}
