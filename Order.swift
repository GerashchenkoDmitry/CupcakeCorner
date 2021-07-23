import Foundation

final class OrderClass: ObservableObject {
  @Published var order = Order()
}

struct Order: Codable {
  
  static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
  
  var type = 0
  var quantity = 3
  
  var specialRequestEnabled = false {
    didSet {
      if specialRequestEnabled == false {
        extraFrosting = false
        addSprinkles = false
      }
    }
  }
var extraFrosting = false
   var addSprinkles = false
  
  var name = ""
  var streetAdress = ""
  var city = ""
  var zip = ""
  
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
}
