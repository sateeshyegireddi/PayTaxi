//
//  APIHandler.swift
//  PayTaxi
//
//  Created by Sateesh on 5/2/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import CoreLocation

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
//            request.addValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.deviceUDID)
//            request.addValue(UtilityFunctions().getApiToken(), forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.apiToken)
//            request.addValue(UtilityFunctions().deviceToken(), forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.deviceToken)
//            request.addValue(GlobalConstants.APIHeaderFieldValues.deviceType, forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.deviceType)
//            request.addValue(UtilityFunctions().currentLanguage(), forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.language)
//            request.addValue(UtilityFunctions().getIPAddressOfNetworkInterface()[1], forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.ipAddress)
//            request.addValue(UtilityFunctions().getAuthToken(), forHTTPHeaderField: GlobalConstants.APIHeaderFieldKeys.authToken)
            
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
                        request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue) ?? "POST Empty")

                        //Create and send encrypted data
//                        let paramsDictionary = parameters!
//                        let paramsData = try JSONSerialization.data(withJSONObject: paramsDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
//                        let parametersString = String.init(data: paramsData, encoding: String.Encoding.utf8)
//                        let encryptedData = parametersString?.encryptedString ?? ""
//                        let body = ["encryptedData": encryptedData]
//                        let bodyData = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
//                        request.httpBody = bodyData
//
//                        print(parametersString!)
                        
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
            
            session.dataTask(with: request) { (data, response, error) in
                
                guard data != nil && error == nil else {
                    completionHandler(false, nil, "Session has timed out")
                    return
                }
                
                //Request Response
                //Test if an error have
                if let strError = error?.localizedDescription {
                    
                    //Error has been enconter with the request return error message to the user
                    completionHandler(false, nil, strError)
                } else {
                    
                    //Query sucessfull
                    do {
                        //Get the JSON data
                        let responseDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        let jsonString = String(data: data!, encoding: .utf8)
                        print("JSON RESPONSE: ---> \(String(describing: jsonString?.replacingOccurrences(of: "\\", with: "")))")
                        print("responseDict \(responseDict)")
                        
                        //Check if the query have been successful
                        if let status = responseDict["status"] as? Int {
                            
                            //Status is OK, everything is going perfect :)
                            if status == 200 {
                              
                                //Check if the responseDict as response
                                if let apiResponseDict = responseDict["resultArray"] as? [String: Any] {

                                    //Response and query have been successful return data dictionary
                                    completionHandler(true, apiResponseDict, nil)

                                } else {

                                    //Response key not found
                                    completionHandler(false, nil, self.extractErrorMessage(responseDict: responseDict))
                                }
                            } else if status == 201 {
                                
                                //Status is not good, some fields are missing from front-end :(
                                
                                //The query have been unsuccuessful show error message to the user
                                completionHandler(false, nil, self.extractErrorMessage(responseDict: responseDict))
                                
                            } else if status == 500 {
                                
                                //There is issue at server end ;(
                            } else {
                                
                                //The query have been unseccuessful show error message to the user
                                completionHandler(false, nil, self.extractErrorMessage(responseDict: responseDict))
                            }

                        } else {
                            
                            //Info status key not found
                            completionHandler(false, nil, self.extractErrorMessage(responseDict: responseDict))
                        }
                        
                    } catch let catchError as NSError{
                        
                        //Issue has been enconter when parsing JSON return error message
                        completionHandler(false, nil, "JSON Parser has encountered an issue parse response, \(catchError.localizedDescription)")
                    }
                }
            }.resume()
            session.finishTasksAndInvalidate()
            /*
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
            */
            
        } else {
            
            //Show internet not avaible message to user
            UtilityFunctions().showInternetNotAvailable()
            
            //Internet connection not available return error
            completionHandler(false, nil, GlobalConstants.Errors.internetConnectionError)
        }
    }
    
    private func extractErrorMessage(responseDict: [String: Any]?) -> String {
        
        //Init variables
        var errorMessage = ""
        
        //Check if there is any error message
        if let messages = responseDict?["displayMsge"] as? [String: Any] {
            
            //Detailed message found look through it
            for detailedMessage in messages.values {
                
                errorMessage += "\(detailedMessage), "
            }
            
            //Remove the last two characters
            errorMessage.remove(at: errorMessage.index(before: errorMessage.endIndex))
            errorMessage.remove(at: errorMessage.index(before: errorMessage.endIndex))
            
        } else if let message = responseDict?["displayMsge"] as? String {
            
            //Set error message to original object
            errorMessage = message
            
        } else {
            
            //Generate default generic error message
            errorMessage = "API Response invalid"
        }
        
        //Return error message
        return errorMessage
    }
    
    private func getHeaderFieldsDictionary() -> [String: Any] {
        
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
    
    private func convertJSONtoEncryptedString(_ paramsDictionary: [String: Any]) -> String {
        
        do {
            let paramsData = try JSONSerialization.data(withJSONObject: paramsDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            let parametersString = String.init(data: paramsData, encoding: String.Encoding.utf8)
            return parametersString?.encryptedString ?? ""
        } catch let error {
            print(error)
        }
        return ""
    }
    
    //MARK: - Google Maps -
    fileprivate func sendRequestToGoogleMaps(withUrl: String, parameters: [String: Any]?, httpMethod: HTTPMethod, completionHandler: @escaping (_ success: Bool, _ response: [String: Any]?, _ error: String?) ->()) {
        
        //Check that there is an internet connection available before to send the request
        if UtilityFunctions().connectionToInternetIsAvailable() {
            
            //Create request
            var request = URLRequest(url: URL(string: withUrl)!)
            request.timeoutInterval = 30
            
            //Set http request method type
            if httpMethod == .get {
                
                request.httpMethod = "GET"
            } else {
                
                request.httpMethod = "POST"
            }
            
            print("Request URL: \(String(describing: request.url))")
            print("Request httpBody: \(String(describing: request.httpBody))")
            print("Request httpMethod: \(String(describing: request.httpMethod))")
            print("Request allHTTPHeaderFields: \(String(describing: request.allHTTPHeaderFields))")
            
            //Create session configuration
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = TimeInterval(30)
            sessionConfig.timeoutIntervalForResource = TimeInterval(30)
            let session = URLSession(configuration: sessionConfig)
            
            session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                guard data != nil && error == nil else {
                    completionHandler(false, nil, "Session has timed out")
                    return
                }
                
                //Request Response
                //Test if an error have
                if let strError = error?.localizedDescription {
                    
                    //Error has been enconter with the request return error message to the user
                    completionHandler(false, nil, strError)
                } else {
                    
                    //Query sucessfull
                    do {
                        //Get the JSON data
                        let responseDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                        
                        let jsonString = String(data: data!, encoding: .utf8)
                        print("JSON RESPONSE: ---> \(String(describing: jsonString?.replacingOccurrences(of: "\\", with: "")))")
                        print("responseDict \(responseDict)")
                        
                        //Check if the query have been successful
                        if let status = responseDict["status"] as? String {
                            
                            if status == GlobalConstants.GoogleAPIResponseStatus.ok {
                                
                                //Response and query have been successful return data dictionary
                                completionHandler(true, responseDict, nil)

                            } else {
                                
                                //Extract error from response
                                let error = responseDict["error_message"] as? String ?? ""
                                
                                //Error occured in response return the message
                                completionHandler(false, nil, error)
                            }
                        } else {
                            
                            //Extract error from response
                            let error = responseDict["error_message"] as? String ?? ""
                            
                            //Error occured in response return the message
                            completionHandler(false, nil, error)
                        }
                        
                    } catch let catchError as NSError {
                        
                        //Issue has been encontered when parsing JSON return error message
                        completionHandler(false, nil, "JSON Parser has encountered an issue parse response, \(catchError.localizedDescription)")
                    }
                }
            }).resume()
            session.finishTasksAndInvalidate()
        } else {
            
            //Internet connection not available return error
            completionHandler(false, nil, GlobalConstants.Errors.internetConnectionError)
        }
    }
    
    ///Get the most efficient routes between two geo-coordinates
    /// - parameter source: The address, textual latitude/longitude value, or place ID from which you wish to calculate directions. Eg. origin=78.1234,78.56416; origin=24+Sussex+Drive+Ottawa+ON; origin=place_id:ChIJ3S-JXmauEmsRUcIaWtf4MzE;
    /// - parameter destination: The address, textual latitude/longitude value, or place ID to which you wish to calculate directions. Eg. destination=78.1234,78.56416; destination=24+Sussex+Drive+Ottawa+ON; destination=place_id:ChIJ3S-JXmauEmsRUcIaWtf4MzE;
    /// - parameter completionHandler: The callback will get called after fetching the response from server.
    /// - parameter distance: The distance between source and destination in meters.
    /// - parameter duration: The time takes to reach destination from source in seconds.
    /// - parameter polylinePoints: The polyline is an approximate (smoothed) path of the resulting directions. It is an encoded polyline representation of the route.
    /// - parameter error: The error received from server/user.
    func getRoutes(from source: String, to destination: String, completionHandler handler: @escaping (_ success: Bool, _ distance: String?, _ duration: String?, _ polylinePoints: String?, _ error: String?) ->()) {
        
        let baseUrl = "\(GlobalConstants.GoogleAPI.directions)origin=\(source)&destination=\(destination)&mode=\(GlobalConstants.TravelMode.driving)&key=\(GlobalConstants.GoogleKeys.APIKey)"
        //https://maps.googleapis.com/maps/api/directions/json?origin=17.25,78.20&destination=17.78,78.60&mode=driving&key=AIzaSyBUHL8D1R31ARmKvXmig-PyohDSP9FKKSA
        sendRequestToGoogleMaps(withUrl: baseUrl, parameters: nil, httpMethod: .get, completionHandler: { (success, response, error) in
            
            //On success
            if success {
                
                var distance = ""
                var duration = ""
                var polyLinePoint = ""
                
                //Check if response is nil
                if response != nil {
                    
                    //Extract routes from the response
                    if let routes = response!["routes"] as? [[String: Any]] {
                        
                        //Check if the routes are exists
                        if routes.count > 0 {
                            
                            //Extract overview polyline from the routes array
                            if let overlayPolyline = routes[0]["overview_polyline"] as? [String: Any] {
                                
                                polyLinePoint = overlayPolyline["points"] as? String ?? ""
                            }
                            
                            //Extract legs from the routes array
                            if let legs = routes[0]["legs"] as? [[String: Any]] {
                                
                                //Check if the legs are exists
                                if legs.count > 0 {
                                    
                                    //Extract distance from the response
                                    if let distanceDict = legs[0]["distance"] as? [String: Any] {
                                        
                                        distance = distanceDict["text"] as? String ?? ""
                                    }
                                    
                                    //Extract duration from the response
                                    if let durationDict = legs[0]["duration"] as? [String: Any] {
                                        
                                        duration = durationDict["text"] as? String ?? ""
                                    }
                                }
                            }
                        }
                    }
                }
                
                handler(true, distance, duration, polyLinePoint, nil)
            } else {
                
                handler(false, nil, nil, nil, error)
            }
        })
    }
    
    func address(from location: CLLocationCoordinate2D, completionHandler handler: @escaping(_ sucess: Bool, _ address: String?, _ error: String?) -> ()) {
        
        let baseUrl = "\(GlobalConstants.GoogleAPI.geocode)latlng=\(location.latitude),\(location.longitude)&sensor=true&key=\(GlobalConstants.GoogleKeys.APIKey)"
        
        sendRequestToGoogleMaps(withUrl: baseUrl, parameters: nil, httpMethod: .get) { (success, response, error) in
            
            //On suceess
            if success {
                
                var address = ""
                
                //Check if response is nil
                if response != nil {
                    
                    //Extract results from response
                    if let results = response!["results"] as? [[String: Any]] {
                        
                        //Check if results are exist
                        if results.count > 0 {
                            
                            //Extract address from result
                            let result = results[0]
                            address = result["formatted_address"] as? String ?? ""
                        }
                    }
                }
                handler(true, address, error)
                
            } else {
                
                //No success response from Google, show error message to user
                handler(false, nil, error)
            }
        }

    }
    
    //MARK: - User API Requests -
    
    func loginUser(with parameters: [String: Any], completionHandler handler: @escaping (_ success: Bool, _ error: String?) ->() ) {
        
        sendRequest(withUrl: GlobalConstants.API.login, parameters: parameters, httpMethod: .post) { (success, response, error) in
            
            if success {
                
                //Check response is nil
                if response != nil {
                    
                    //Save user locally
                    handler(true, nil)
                    
                } else {
                    
                    handler(false, error)
                }
            } else {
                
                handler(false, error)
            }
        }
    }
    
    func registerUser(parameters: [String: Any], completionHandler handler: @escaping (_ success: Bool, _ userId: String?, _ otpId: String?, _ error: String?) ->() ) {
        
        sendRequest(withUrl: GlobalConstants.API.userRegistration, parameters: parameters, httpMethod: .post) { (success, response, error) in
            
            if success {
                
                //Check response is nil
                if response != nil {
                    
                    //Extract userId, otpId from respose
                    let userId = UtilityFunctions().parseString(in: response!, for: "userId")
                    let otpId = UtilityFunctions().parseString(in: response!, for: "otpId")
                    
                    handler(true, userId, otpId, error)
                    
                } else {
                    
                    handler(false, nil, nil, error)
                }
            } else {
                
                handler(false, nil, nil, error)
            }
        }
    }
    
    func verifyOTP(parameters: [String: Any], completionHandler handler: @escaping (_ success: Bool, _ error: String?) ->() ) {
        
        sendRequest(withUrl: GlobalConstants.API.verifyOTP, parameters: parameters, httpMethod: .post) { (success, response, error) in
            
            if success {
                
                //Check response is nil
                if response != nil {
                    
                    handler(true, error)
                    
                } else {
                    
                    handler(false, error)
                }
            } else {
                
                handler(false, error)
            }
        }
    }
    
    func resendOTP(parameters: [String: Any], completionHandler handler: @escaping (_ success: Bool, _ error: String?) ->() ) {
        
        sendRequest(withUrl: GlobalConstants.API.resendOTP, parameters: parameters, httpMethod: .post) { (success, response, error) in
            
            if success {
                
                //Check response is nil
                if response != nil {
                    
                    handler(true, error)
                    
                } else {
                    
                    handler(false, error)
                }
            } else {
                
                handler(false, error)
            }
        }
    }
    
    //MARK: - Driver API Requests -
    
    func loginDriver(with parameters: [String: Any], completionHandler handler: @escaping (_ success: Bool, _ error: String?) ->() ) {
        
        sendRequest(withUrl: GlobalConstants.API.driverLogin, parameters: parameters, httpMethod: .post) { (success, response, error) in
            
            if success {
                
                //Check response is nil
                if response != nil {
                    
                    handler(true, error)
                    
                } else {
                    
                    handler(false, error)
                }
            } else {
                
                handler(false, error)
            }
        }
    }
 
    func registrationDriver(parameters: [String: Any], completionHandler handler: @escaping (_ success: Bool, _ error: String?) ->() ) {
        
        sendRequest(withUrl: GlobalConstants.API.driverRegistration, parameters: parameters, httpMethod: .post) { (success, response, error) in
            
            if success {
                
                //Check response is nil
                if response != nil {
                    
                    handler(true, error)
                    
                } else {
                    
                    handler(false, error)
                }
            } else {
                
                handler(false, error)
            }
        }
    }

}
