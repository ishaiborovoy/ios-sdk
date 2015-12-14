/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import Alamofire

/**
* FacebookAuthenticationStrategy will authenticate using a provided Facebook OAuth token
* generated by the Facebook Login SDK. 
*/
public class FacebookAuthenticationStrategy: AuthenticationStrategy {
    
    public var token: String?
    
    let tokenURL: String!
    var fbToken: String!
 
    
    /**
     Facebook authentication requires sending an OAuth token that the user created with their
     Facebook account credentials and obtained typically through the Facebook SDK. The OAuth token 
     and the URL for the server that validates the token must be provided.
     
     - parameter fbToken: Facebook OAuth token generated by the Facebook Login SDK
     
     */
    public init(tokenURL: String, fbToken: String) {
        
        self.fbToken = fbToken
        self.tokenURL = tokenURL
        
    }
    
    /**
     Fetches a token on a token granting server.
     
     - parameter completionHandler: <#completionHandler description#>
     - parameter error:             <#error description#>
     */
    public func getToken(completionHandler: (token: String?, error: NSError?) -> Void) {
        
        let url = "\(tokenURL)?fbtoken=\(fbToken)"
        
        Alamofire.request(.GET, url)
            .responseJSON {
                
                response in
                
                
                if let JSON = response.result.value {
                    
                    
                    if let rtoken = JSON["token"] as? String {
                        self.token = rtoken
                        completionHandler(token: self.token, error: nil)
                    } else {
                        let err = NSError.createWatsonError(503, description: "Facebook rejected token")
                        completionHandler(token: nil, error: err)
                    }
                    
                    
                   
                } else {
                    completionHandler(token: nil,
                        error: NSError.createWatsonError(400, description: "Could not parse response"))
                }
                
                
        }
        
    }

    
}