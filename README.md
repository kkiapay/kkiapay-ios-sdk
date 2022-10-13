# KKiaPay Swift SDK for iOS

[KKiapay](https://kkiapay.me) is developer friendly solution that allows you to accept mobile money and credit card payments
in your application or website.

Before using this SDK, make sure you have a right Merchant Account on [KKiapay](https://kkiapay.me), otherwise [go](https://kkiapay.me)
and create your account is free and without pain :sunglasses:.


## Usage
##### Add the KKiaPay package to your project
You can add this package to you project using the Swift Package Manager.

##### Import the KKiaPay module
```swift
import KKiaPaySDK;
```

##### Create a view model instance to use later

```swift
@ObservedObject var viewModel = KKiaPayViewModel()
```

##### Initialise the Kkiapay Instance

```swift
private var kkiaPay: KKiaPay{
    KKiaPay(amount: "3000",
            phone: "97000000",
            data: "Hello world",
            publicAPIKey: "xxxxxxxxxxxxxxxxxxx",
            sandbox: true,//set this to false in production
            theme: "#4E6BFC",
            name: "John Doe",
            email:"user@email.com",
            callback: "https://redirect.kkiapay.com",
            viewModel:viewModel
    )
}
```

##### Get the transaction data back 
Once the payment is successful, the KKiaPayViewModel sends a KKiaPayTransactionData to the calling view via the onReceive callback.
```swift
kkiaPay.onReceive(self.viewModel.paymentData.receive(on: RunLoop.main)){paymentData in
    
    if(paymentData.isSuccessful){
        print("The amount of the transaction is " + paymentData.amount+" with id "+paymentData.transactionId)
        showWebView = false
    }else{
        print("The payment was not successful")
    }
}
```

The onReceive function of the kkiaPay instance listens to the state of the paymentData and exposes it. 

## Example

```swift
import SwiftUI
import KKiaPaySDK

struct ContentView: View {
        //Create a view model instance to use later
        @ObservedObject var viewModel = KKiaPayViewModel()
        @State private var showWebView = false
        @State var text = "Pay Now"
        
        //Initialise the Kkiapay Instance
        private var kkiaPay: KKiaPay{
            KKiaPay(amount: 3000,
                    phone: "97000000",
                    data: "Hello world",
                    publicAPIKey: "xxxxxxxxxxxxxxxxxxx",
                    sandbox: true,//set this to false in production
                    theme: "#4E6BFC",
                    name: "John Doe",
                    email:"user@email.com",
                    callback: "https://redirect.kkiapay.com",
                    viewModel:viewModel
            )
        }
        
        var body: some View {
            Button {
                showWebView.toggle()
            } label: {
                Text(self.text)
            }
            .sheet(isPresented: $showWebView) {
                
                kkiaPay.onReceive(self.viewModel.paymentData.receive(on: RunLoop.main)){paymentData in
                    
                    if(paymentData.isSuccessful){
                        
                        self.text = "PAYMENT WAS SUCCESSFUL \n\nThe amount of the transaction is \(paymentData.amount) Fcfa with id \(paymentData.transactionId)"
                    
                        print("The amount of the transaction is \(paymentData.amount) with id \(paymentData.transactionId)")
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

```

### Reference

<table>
<tr><td>Argument</td><td>Type</td><td>Required</td><td>Details</td></tr>
<tr><td>phone</td><td>String</td><td>Yes</td><td>Valid mobile money number to debit. ex : 22997000000 </td></tr>
<tr><td>amount</td><td>Numeric</td><td>Yes</td><td>Amount to debit from user account (XOF) </td></tr>
<tr><td>name</td><td>String</td><td>No</td><td>Client firstname and lastname </td></tr>
<tr><td>email</td><td>String</td><td>No</td><td>Client email address </td></tr>
<tr><td>theme</td><td>String</td><td>No</td><td> the hexadecimal code of the color you want to give to your widget </td></tr>
<tr><td>apikey</td><td>String</td><td>Yes</td><td>public api key</td></tr>
<tr><td>sandbox</td><td>Boolean</td><td>No</td><td>The true value of this attribute allows you to switch to test mode</td></tr>
<tr><td>successCallback</td><td>Function</td><td>No</td><td>This function is called once the payment has been successfully made</td></tr>
</table>

### Issues and feedback

Please file [issues](https://github.com/kkiapay/kkiapay-ios-sdk/issues/new)
to send feedback or report a bug. Thank you!
