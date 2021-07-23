//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Дмитрий Геращенко on 16.07.2021.
//

import SwiftUI

struct AddressView: View {
  
  @ObservedObject var order: Order
  
    var body: some View {
      Form {
        Section {
          TextField("Name", text: $order.name)
          TextField("Street Adress", text: $order.streetAdress)
          TextField("City", text: $order.city)
          TextField("Zip", text: $order.zip)
        }
        Section {
          NavigationLink(
            destination: CheckoutView(order: order)) {
              Text("Check out")
            }
          .disabled(order.hasValidAddress == false)
        }
      }
      .navigationBarTitle("Delivery address", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
