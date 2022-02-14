//
//  KKiaPay.swift
//
//
//  Created by Seth-Pharès Gnavo on February 4, 2022.
//
#if canImport(UIKit)
import WebKit
import SwiftUI

import Foundation
import UIKit
import Combine

public struct KKiaPay: UIViewRepresentable {
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    let amount:String?
    let phone:String?
    let data:String?
    let publicAPIKey:String?
    let sandbox:Bool?
    let theme:String?
    let name:String?
    let callback:String?
    
    @ObservedObject public var viewModel : KKiaPayViewModel
    
    public init(amount:String,
                phone:String,
                publicAPIKey:String,
                data:String,
                sandbox:Bool,
                theme:String,
                name:String,
                callback:String,
                viewModel:KKiaPayViewModel) {
        self.amount=amount
        self.phone=phone
        self.publicAPIKey=publicAPIKey
        self.data=data
        self.sandbox=sandbox
        self.theme=theme
        self.name=name
        self.callback=callback
        self.viewModel=viewModel
    }
    
    private func base64EncodedUrl() -> String {
        
        let encodedData = Data("{\"amount\":\"\(amount ?? "")\",\"phone\": \"\(phone ?? "")\",\"data\": \"\(data ?? "")\",\"key\": \"\(publicAPIKey ?? "")\",\"sandbox\":\(sandbox ?? true),\"theme\": \"\(theme ?? "")\", \"name\": \"\(name ?? "")\",\"callback\": \"\(callback ?? "")\",\"sdk\":\"android\",\"host\":\"com.package.name\",\"reason\":\"\"}".utf8).base64EncodedString()
        
        return "https://widget-v2.kkiapay.me/?="+encodedData
        
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        return webView
    }
    
    public func updateUIView(_ webView: WKWebView, context: Context) {
        let url = URL(string: base64EncodedUrl())
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    public class Coordinator : NSObject, WKNavigationDelegate {
        var parent: KKiaPay
        var valueSubscriber: AnyCancellable? = nil
        var webViewNavigationSubscriber: AnyCancellable? = nil
        
        init(_ uiWebView: KKiaPay) {
            self.parent = uiWebView
        }
        
        deinit {
            valueSubscriber?.cancel()
            webViewNavigationSubscriber?.cancel()
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        }
        
        // This function is essential for intercepting every navigation in the webview
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            let urlString = navigationAction.request.url?.absoluteString
            
            if(urlString!.contains("transaction_id")){//Payment successful
                print("KKIAPAYSDK: PAYMENT WAS SUCCESSFUL")
                
                let transactionId = getQueryStringParameter(url: urlString!, param: "transaction_id")
                
                self.parent.viewModel.paymentData.send(KKiaPayData(amount: self.parent.amount ?? "",
                                                                   transactionId:  transactionId ?? "",isSuccessful:true))
            }else{
                
                self.parent.viewModel.paymentData.send(KKiaPayData(amount: self.parent.amount ?? "",transactionId:  "",isSuccessful:false))
            }
            
            // This allows the navigation
            decisionHandler(.allow)
        }
        
        private func getQueryStringParameter(url: String, param: String) -> String? {
            guard let url = URLComponents(string: url) else { return nil }
            return url.queryItems?.first(where: { $0.name == param })?.value
        }
    }
}

open class KKiaPayViewModel: ObservableObject {
    open   var paymentData = PassthroughSubject<KKiaPayData,Never>()
    public  init(){}
}

open class KKiaPayData{
    public let isSuccessful:Bool
    public let amount:String
    public let transactionId:String
    
    init(amount:String, transactionId:String,isSuccessful:Bool){
        self.isSuccessful=isSuccessful
        self.amount=amount
        self.transactionId=transactionId
    }
}
#endif