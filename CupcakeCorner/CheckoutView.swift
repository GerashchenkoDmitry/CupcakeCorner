//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Дмитрий Геращенко on 21.07.2021.
//

import SwiftUI

struct CheckoutView: View {
  
  @ObservedObject var order: Order
  
  @State private var confirmationMessage = ""
  @State private var showingConfirmation = false
  
  @State private var failInfo = ""
  @State private var showingFailAlert = false
  
  var body: some View {
    GeometryReader { geo in
      ScrollView {
        VStack {
          Image("cupcakes")
            .resizable()
            .scaledToFit()
            .frame(width:
                    geo.size.width
            )
          Text("Your total is: \(order.cost, specifier: "%.2f")$")
            .font(.title)
          
          Button("Place order") {
            self.placeOrder()
          }
          .padding()
        }
      }
      .navigationBarTitle("Check out", displayMode: .inline)
    }
    .alert(isPresented: $showingConfirmation) {
      Alert(title: Text("Thank You!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
    }
    .alert(isPresented: $showingFailAlert) {
      Alert(title: Text("Connection issue"), message: Text("Server are not responsible. Please check your connection."), dismissButton: .default(Text("OK")))
    }
  }
  
  func placeOrder() {
    guard let encoded = try? JSONEncoder().encode(order) else {
      print("Failed to encode order!")
      return
    }
    
    guard let url = URL(string: "https://reqres.in/api/cupcakes") else {
      return
    }
    
    var request = URLRequest(url: url)
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = encoded
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print("No data in response. \(error?.localizedDescription ?? "Unknown error.")")
        self.showingFailAlert = true
        return
      }
      if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
        self.confirmationMessage = "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) is on its way!"
        self.showingConfirmation = true
      } else {
        print("Invalid response drom the server!")
      }
    }
    .resume()
  }
}

struct CheckoutView_Previews: PreviewProvider {
  static var previews: some View {
    CheckoutView(order: Order())
  }
}
