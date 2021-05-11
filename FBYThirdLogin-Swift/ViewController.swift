//
//  ViewController.swift
//  FBYThirdLogin-Swift
//
//  Created by fanbaoying on 2021/5/11.
//

import UIKit
import AuthenticationServices
import SafariServices

class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {

    var session: ASWebAuthenticationSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // val GitHub、Google、SignInWithApple
        oauthLogin(type: "GitHub")
    }
    
    func oauthLogin(type: String) {
        let redirectUri = "com.fby.thirdlogin://success"
        print("redirectUri: \(redirectUri)")
//        let loginURL = Configuration.shared.awsConfiguration.authURL + "/authorize" + "?identity_provider=" + type + "&redirect_uri=" + redirectUri + "&response_type=CODE&client_id=" + Configuration.shared.awsConfiguration.appClientId
        let loginURL = "https://xxx.xxx.xxx.com/oauth2/xxx?identity_provider=" + type + "&redirect_uri=com.fby.thirdlogin://success&response_type=CODE&client_id=88i6bcn6f8rjuerfvq77nmaq55"
        
        session = ASWebAuthenticationSession(url: URL(string: loginURL)!, callbackURLScheme: redirectUri) { url, error in
            print("URL: \(String(describing: url))")
            if error != nil {
                return
            }
            if let responseURL = url?.absoluteString {
                let components = responseURL.components(separatedBy: "#")
                for item in components {
                    if item.contains("code") {
                        let tokens = item.components(separatedBy: "&")
                        for token in tokens {
                            if token.contains("code") {
                                let idTokenInfo = token.components(separatedBy: "=")
                                if idTokenInfo.count > 1 {
                                    let code = idTokenInfo[1]
                                    print("code: \(code)")
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        session.presentationContextProvider = self
        session.start()
    }

    // #pragma mark - ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }

}

