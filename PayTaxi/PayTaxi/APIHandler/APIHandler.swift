//
//  APIHandler.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit

private enum HTTPMethod {
    case post
    case get
}

class APIHandler: NSObject {
    
    //MARK: - Common Functions
    private func sendRequest(withUrl: String, parameters: [String: Any]?, httpMethod: HTTPMethod, completionHandler: @escaping (_ success: Bool, _ response: [String: Any]?, _ error: String?) ->()) {
        
        //Check that there is an internet connection available before to send the request
        if UtilityFunctions().connectionToInternetIsAvailable() {
            
            //Create request
            var request = URLRequest(url: URL(string: "\(GlobalConstants.API.baseURL)\(withUrl)")!)
            
            //Add header fields
            request.addValue(GlobalConstants.APIHeaderFieldValues.applicationJson, forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.contentType)
            request.addValue(getHeaderFieldsDictionary().description, forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.deviceInfo)
            request.addValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.deviceUDID)
            request.addValue(UtilityFunctions().getApiToken(), forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.apiToken)
            request.addValue(UtilityFunctions().deviceToken(), forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.deviceToken)
            request.addValue(GlobalConstants.APIHeaderFieldValues.deviceType, forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.deviceType)
            request.addValue(UtilityFunctions().currentLanguage(), forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.language)
            request.addValue(UtilityFunctions().getIPAddressOfNetworkInterface()[1], forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.ipAddress)
            request.addValue(UtilityFunctions().getAuthToken(), forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.authToken)
            
            
            request.timeoutInterval = 30
            
            //Check which http method this API call are using
            switch httpMethod {
            case HTTPMethod.post:
                
                //Post method
                request.httpMethod = "POST"
                
                //Check if there are parameters to send
                if parameters != nil {
                    
                    do {
                        
                        //Parameters available create JSON data
                        //                        request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions.prettyPrinted)
                        
                        //Create and send encrypted data
                        let paramsDictionary = parameters!
                        let paramsData = try JSONSerialization.data(withJSONObject: paramsDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let parametersString = String.init(data: paramsData, encoding: String.Encoding.utf8)
                        let encryptedData = parametersString?.encryptedString ?? ""
                        let body = ["encryptedData": encryptedData]
                        let bodyData = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
                        request.httpBody = bodyData
                        
                        print(parametersString!)
                        
                    } catch let catchError {
                        
                        //Issue has been enconter return error message
                        
                        print("Error---\(catchError.localizedDescription)")
                        completionHandler(false, nil,"Error_Message".localized)
                        
                        //  completionHandler(false, nil, "JSON Parser has encountered an issue to create JSON POST value, \(catchError.localizedDescription)")
                    }
                }
                break
            case HTTPMethod.get:
                
                //Get method
                request.httpMethod = "GET"
                
                break
            }
            
            print("Request URL: \(String(describing: request.url))")
            print("Request httpBody: \(String(describing: request.httpBody))")
            print("Request httpMethod: \(String(describing: request.httpMethod))")
            print("Request allHTTPHeaderFields: \(String(describing: request.allHTTPHeaderFields))")
            
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = TimeInterval(30)
            sessionConfig.timeoutIntervalForResource = TimeInterval(30)
            let session = URLSession(configuration: sessionConfig)
            
            //let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                guard data != nil && error == nil else {
                    completionHandler(false, nil, "Session has timed out")
                    return
                }
                //Save auth token to keychain
                if let authToken = (response as? HTTPURLResponse)?.allHeaderFields["auth-token"] as? String {
                    
                    UtilityFunctions().saveAuthToken(authToken)
                }
                if let sessionExpired = (response as? HTTPURLResponse)?.allHeaderFields["session-expired"] as? String {
                    
                    if sessionExpired == "N" {
                        //Request Response
                        //Test if an error have
                        if let strError = error?.localizedDescription {
                            
                            //Error has been enconter with the request return error message to the user
                            completionHandler(false, nil, strError)
                        } else {
                            
                            //Query sucessfull
                            do {
                                
                                var responseDict = [String: Any]()
                                
                                //Create the JSON encrypted string from data
                                let encryptedString = String.init(data: data!, encoding: String.Encoding.utf8)!
                                
                                //Decrypt string
                                let responseString = encryptedString.decryptedString
                                
                                //Convert
                                if let responsedata = responseString.data(using: String.Encoding.utf8) {
                                    
                                    responseDict = try JSONSerialization.jsonObject(with: responsedata, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                                    print("JSON RESPONSE: ---> \(String(describing: responseString.replacingOccurrences(of: "\\", with: "")))")
                                    print("responseDict \(responseDict)")
                                }
                                
                                //                        let jsonString = String(data: data!, encoding: .utf8)
                                //                        print("JSON RESPONSE: ---> \(String(describing: jsonString?.replacingOccurrences(of: "\\", with: "")))")
                                //                        print("responseDict \(responseDict)")
                                
                                //Check if the query have been successful
                                if let isError = responseDict["is_error"] as? Bool {
                                    if !isError {
                                        
                                        //Check if the responseDict as response
                                        if let apiResponseDict = responseDict["res_data"] as? [String: Any] {
                                            
                                            //Response and query have been successful return data dictionary
                                            completionHandler(true, apiResponseDict, self.extractErrorMessage(responseDict: responseDict))
                                            
                                        } else if let apiResponseDict = responseDict["res_data"] as? [[String: Any]] {
                                            
                                            //Response and query have been successful create and return data dictionary
                                            let response = ["response_data": apiResponseDict]
                                            completionHandler(true, response, self.extractErrorMessage(responseDict: responseDict))
                                            
                                        } else if let apiResponseString = responseDict["res_data"] as? String {
                                            
                                            //Response and query have been successful create and return data dictionary
                                            let response = ["response_data": apiResponseString]
                                            completionHandler(true, response, self.extractErrorMessage(responseDict: responseDict))
                                            
                                        } else {
                                            
                                            //Response key not found
                                            completionHandler(true, nil, self.extractErrorMessage(responseDict: responseDict))
                                        }
                                    } else {
                                        
                                        //The query have been unseccuessful show error message to the user
                                        completionHandler(false, nil, self.extractErrorMessage(responseDict: responseDict))
                                    }
                                } else {
                                    
                                    //Info status key not found
                                    completionHandler(false, nil, self.extractErrorMessage(responseDict: responseDict))
                                }
                                
                            } catch let catchError as NSError {
                                if let statusCode = (response as? HTTPURLResponse)?.allHeaderFields["status code"] as? String {
                                    
                                    //Issue has been enconter when parsing JSON return error message
                                    completionHandler(false, nil, "Status Code: \(statusCode) Message: \(catchError.localizedDescription)")
                                } else {
                                    
                                    //Issue has been enconter when parsing JSON return error message
                                    completionHandler(false, nil, "Something went wrong. Please try again after some time")
                                    
                                    //   completionHandler(false, nil, "JSON Parser has encountered an issue parse response, \(catchError.localizedDescription)")
                                }
                            }
                        }
                    } else {
                        
                        //clear user data, auto login
                        UtilityFunctions().clearKeychainData()
                        UtilityFunctions().setAutoLogin(false)

                        //Create the JSON encrypted string from data
                        let encryptedString = String.init(data: data!, encoding: String.Encoding.utf8)!
                        
                        //Decrypt string
                        let responseString = encryptedString.decryptedString
                        
                        var responseDict = [String: Any]()
                        
                        do {
                            
                            //Convert
                            if let responsedata = responseString.data(using: String.Encoding.utf8) {
                                
                                responseDict = try JSONSerialization.jsonObject(with: responsedata, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                                print("JSON RESPONSE: ---> \(String(describing: responseString.replacingOccurrences(of: "\\", with: "")))")
                                print("responseDict \(responseDict)")
                            }
                            
                            //Extranct error message from response
                            let error = self.extractErrorMessage(responseDict: responseDict)
                            
                        } catch let error {
                            
                            print("error -- \(error.localizedDescription)")
                        }
                    }
                } else {
                    
                    //Show error to user
                    completionHandler(false, nil, "session-expired key is missing in response!")
                }
                
            }).resume()
            session.finishTasksAndInvalidate()
            
        } else {
            
            //Internet connection not available return error
            completionHandler(false, nil, GlobalConstants.Errors.internetConnectionError)
        }
    }
    
    func extractErrorMessage(responseDict: [String: Any]?) -> String {
        
        //Init variables
        var errorMessage = ""
        
        //Check if there is any error message
        if let messages = responseDict?["display_msg"] as? [String: Any] {
            
            //Detailed message found look through it
            for detailedMessage in messages.values {
                
                errorMessage += "\(detailedMessage), "
            }
            
            //Remove the last two characters
            errorMessage.remove(at: errorMessage.index(before: errorMessage.endIndex))
            errorMessage.remove(at: errorMessage.index(before: errorMessage.endIndex))
            
        } else if let message = responseDict?["display_msg"] as? String {
            
            //Set error message to original object
            errorMessage = message
            
        } else {
            
            //Generate default generic error message
            errorMessage = "API Response invalid"
        }
        
        //Return error message
        return errorMessage
    }
    
    func getHeaderFieldsDictionary() -> [String: Any] {
        
        var dict = [String: Any]()
        dict.updateValue(GlobalConstants.APIHeaderFieldValues.applicationType, forKey: GlobalConstants.APIHeaderFieldKeys.applicationType)
        dict.updateValue(UtilityFunctions().deviceToken(), forKey: GlobalConstants.APIHeaderFieldKeys.deviceToken)
        dict.updateValue(GlobalConstants.APIHeaderFieldValues.deviceType, forKey: GlobalConstants.APIHeaderFieldKeys.deviceType)
//        dict.updateValue(deviceInfo(), forKey: GlobalConstants.APIHeaderFieldKeys.deviceInfo)
        dict.updateValue(UIDevice.current.identifierForVendor!.uuidString, forKey: GlobalConstants.APIHeaderFieldKeys.deviceUDID)
        dict.updateValue(UtilityFunctions().getIPAddressOfNetworkInterface()[1] , forKey: GlobalConstants.APIHeaderFieldKeys.ipAddress)
        dict.updateValue(UtilityFunctions().getApiToken(), forKey: GlobalConstants.APIHeaderFieldKeys.apiToken)
        
        return dict
    }
    
    func convertJSONtoEncryptedString(_ paramsDictionary: [String: Any]) -> String {
        
        do {
            let paramsData = try JSONSerialization.data(withJSONObject: paramsDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            let parametersString = String.init(data: paramsData, encoding: String.Encoding.utf8)
            return parametersString?.encryptedString ?? ""
        } catch let error {
            print(error)
        }
        return ""
    }
    
    //MARK: - User
    
    
    //MARK: - Driver
    
    
}
