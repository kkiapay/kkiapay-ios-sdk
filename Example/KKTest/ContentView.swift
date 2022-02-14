//
//  ContentView.swift
//  KKTest
//
//  Created by Seth-Pharès Gnavo on February 11, 2022.
//

import SwiftUI
import KKiaPaySDK

struct ContentView: View {
        @ObservedObject var viewModel = KKiaPayViewModel()
        @State private var showWebView = false
        
        private var kkiaPay: KKiaPay{
            KKiaPay(amount: "3000",
                    phone: "97000000",
                    publicAPIKey: "f1e7270098f811e99eae1f0cfc677927",
                    data: "Hello world",
                    sandbox: true,
                    theme: "#4E6BFC",
                    name: "John Doe",
                    callback: "http://redirect.kkiapay.com",
                    viewModel:viewModel
            )
        }
        
        var body: some View {
            Button {
                showWebView.toggle()
            } label: {
                Text("Pay")
            }
            .sheet(isPresented: $showWebView) {
                
                kkiaPay.onReceive(self.viewModel.paymentData.receive(on: RunLoop.main)){paymentData in
                    
                    if(paymentData.isSuccessful){
                        print("The amount of the transaction is " + paymentData.amount+" with id "+paymentData.transactionId)
                        showWebView = false
                    }else {
                        print("The payment was not successful")
                    }
                }
                
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
