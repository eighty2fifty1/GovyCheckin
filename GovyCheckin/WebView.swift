//
//  WebView.swift
//  GovyCheckin
//
//  Created by James Ford on 5/26/25.
//

import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {
    var url = URL(string: "https://forms.osi.apps.mil/pages/responsepage.aspx?id=AD4z43fIh0u2rUXpQt4XUItb1mjrY3hAjyLPhTvCkXNUOUxERjNLT1pCUTFGUjlTMlRXMjcwSkdCNC4u&origin=QRCode&route=shorturl)")
    var tagNumber: String
    var driverName: String

    @Binding var shouldReload: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(tagNumber: tagNumber, driverName: driverName)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url!))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if shouldReload {
            uiView.reload()
            DispatchQueue.main.async {
                shouldReload = false // Reset after reload
            }
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let tagNumber: String
        let driverName: String

        init(tagNumber: String, driverName: String) {
            self.tagNumber = tagNumber
            self.driverName = driverName
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let js = """
            const inputs = document.querySelectorAll('input[data-automation-id="textInput"]');
            if (inputs.length >= 2) {
                inputs[0].value = "\(tagNumber)";
                inputs[0].dispatchEvent(new Event('input', { bubbles: true }));
                inputs[1].value = "\(driverName)";
                inputs[1].dispatchEvent(new Event('input', { bubbles: true }));
            }
            """
            webView.evaluateJavaScript(js)
        }
    }
}

#Preview{
    var url = URL(string: "https://forms.osi.apps.mil/pages/responsepage.aspx?id=AD4z43fIh0u2rUXpQt4XUItb1mjrY3hAjyLPhTvCkXNUOUxERjNLT1pCUTFGUjlTMlRXMjcwSkdCNC4u&origin=QRCode&route=shorturl)")
    var tagNumber = "G1002335X"
    var driverName = "AWFC Ford, James"
    WebView(url: url!, tagNumber: tagNumber, driverName: driverName, shouldReload: .constant(false))
}
