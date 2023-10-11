viewController.webView.evaluateJavaScript("document.getElementById('joinEmail').value") {
              
                (result, error) in
                if let result = result {
                    print("email Login")
                    print(result)
                    
                }
            
}

            ![스크린샷 2023-10-11 오후 2 55 06](https://github.com/hyosunglee/swift/assets/24516775/6b36f6de-f926-450c-8050-e5815801af0a)

viewController.webView.evaluateJavaScript("document.getElementsByName('Email').value") {
                (result, error) in
                if let result = result {
                    print("email Login")
                    print(result)
                    
                }
            
}

// getElementsByClassName
func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    web.evaluateJavaScript("document.getElementsByClassName('excerpt')[0].innerText") {(result, error) in
        guard error == nil {
            print(error!)
            return
        }

        print(String(describing: result))
    }
}
