//
//  APIs.swift
//  talkPHR
//
//  Created by Shakeel Ahmed on 3/20/21.
//

import Foundation
import Alamofire
//import SwiftyJSON


struct APIs {
    static var shared = APIs()
    
    func sessionManger(timeOut: Int) -> Session {
        
//        let evaluators: [String: ServerTrustEvaluating] = [
//            "https://bb.fmfb.pk": PublicKeysTrustEvaluator()
//        ]
        let evaluators: [String: ServerTrustEvaluating] = [
            "https://bb.fmfb.pk": PublicKeysTrustEvaluator(
                performDefaultValidation: false,
                validateHost: false
            )
        ]
        let serverTrustManager = ServerTrustManager(
            allHostsMustBeEvaluated: false,
            evaluators: evaluators
        )
        let session = Session(serverTrustManager: serverTrustManager)
        
        return session
        
//
//        let serverTrustPolicies : [String: ServerTrustManager] = ["https://bb.fmfb.pk" : .pinCertificates(certificates: ServerTrustPolicy.certificates(), validateCertificateChain: true, validateHost: true), "insecure.expired-apis.com": .disableEvaluation]
//        let networkSessionManager = Session( serverTrustPolicyManager: ServerTrustPolicyManager(policies:serverTrustPolicies))
//        return networkSessionManager
    }
    static func load(URL: NSURL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL as URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")
                // This is your file-variable:
                // data
            }
            else {
                // Failure
                print("Failure: %@", error.localizedDescription);
            }
        })
        task.resume()
    }
    static func funDownloadFileViaUrl(_ urlString: String, viewController: UIViewController) {
    }
//    static let ipAddress = UIDevice.current.ipAddress() ?? ""
//    static let deviceInfo = UIDevice.modelName
//    static let grantType = "password"
//    static let deviceToken = General_Elements.shared.deviceToken
//    //static let authToken = "bearer \(General_Elements.shared.userProfileData?.data?.accessTokenResponse?.accessToken ?? "")"
//    static let authToken = "bearer \(Constant.kAccessToken)"
//    static let header: HTTPHeaders = ["Content-Type": "application/json"
//
//    static let headerWithToken: HTTPHeaders = ["Content-Type": "application/json"
//                               ,"device_info" : deviceInfo ,
//                               "device_token" : deviceToken ,
//                               "ip" : ipAddress ,
//                               "grant_type" : grantType,
//                               "Authorization" : authToken]
    
    
    static func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    /*
    static func postAPIForFingerPrint(apiName: APIsName.name, parameters: [String: Any], apiAttribute3: [[String:Any]]?, headerWithToken: String? = nil , headers: HTTPHeaders? = nil, viewController: UIViewController? = nil, completion: @escaping(_ response: Data?, Bool, _ errorMsg: String) -> Void) {
                
        var params = [String : Any]()
        
        let stringParamters = APIs.json(from: params)
        //let postData = stringParamters!.data(using: .utf8)
        let completeUrl = APIPath.baseUrl + apiName.rawValue
        
        let url = URL(string: completeUrl)!
        let jsonData = stringParamters!.data(using: .utf8, allowLossyConversion: false)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var token  = ""

        request.addValue(token, forHTTPHeaderField: "Authorization")
//
        
        print("Url: \(completeUrl)")
        print("Parameters: \(parameters)")
        print("Headers: \(token)")
        
        request.httpBody = jsonData
        //print("\(APIs.json(from: parameters)))")
        if let vc = viewController {
            vc.showActivityIndicator2()
        }
        
        AF.request(request.url!, method: .post, parameters: params, encoding:JSONEncoding.default, headers: request.headers)
                    .responseData { response in
//           guard let data = response.data else { return }
//           let json = try? JSON(data:data)
//           if let acc = json?["Account"].string {
//             print(acc)
//           }
//           if let pass = json?["Password"].string {
//             print(pass)
//           }
//        }
//
//        AF.request(request).responseJSON { response in
            print("Response: \(response)")
            if let vc = viewController {
                vc.hideActivityIndicator2()
            }
            switch response.result {
            case .success(let json):
                let modelGetActiveLoan = try? JSONDecoder().decode(NanoLoanApplyViewController.ModelGetLoanCharges.self, from: response.data!)
                print(modelGetActiveLoan)
                
                let serverResponse = JSON(response.value!)
                
                print("Request Headers: \(String(describing: request.allHTTPHeaderFields))")
                print("Request Url: \(String(describing: request.url))")
                print("Request Parameters: \(parameters)")
                print("JSON: \(serverResponse)")
                print("JSON: \(json)")
                let str = String(decoding: response.data!, as: UTF8.self)
print(str)
                switch response.response?.statusCode {
                case 200 :
                    if serverResponse["responsecode"] == 1 {
                        completion(response.data, true, "")
                    }
                    else {
                        completion(response.data, false, serverResponse["message"].string ?? "")
                    }
                    break
                default :
                    completion(response.data, false, serverResponse["message"].string ?? "")
                    break
                }
            case .failure( _):
                var errorMessage = ""
                if let error = response.error?.localizedDescription {
                    let errorArray = error.components(separatedBy: ":")
                    errorMessage = errorArray.count > 1 ? errorArray[1] : error
                    completion(nil, false, errorMessage)
                }
                else {
                    errorMessage = response.error.debugDescription
                    completion(nil, false, response.error.debugDescription)
                }
                break
            }
        }
    }
     
    */
    

//    static func getAPI(apiName: APIsName.name, parameters: [String: Any]? = nil, headerWithToken: String? = nil , headers: HTTPHeaders? = nil, viewController: UIViewController? = nil, completion: @escaping(_ response: Data?, Bool, _ errorMsg: String) -> Void) {
//        
//        let baseClass = BaseClassVC()
//        
//        let completeUrl = APIPath.baseUrl + apiName.rawValue
//        
//        let url = URL(string: completeUrl)!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        var tempHeader = ""
//        var token  = ""
//                if apiName == .updateAccountStatus {
//                    token = DataManager.instance.loginResponseToken ?? ""
//                    token = DataManager.instance.accessToken ?? ""
//                }
//                else if headerWithToken != nil {
//                    token = headerWithToken!
//                }
//                else {
//                    token = "\(DataManager.instance.accessToken ?? "")"
//                }
//                request.addValue(token, forHTTPHeaderField: "Authorization")
//
//        
//        print("Url: \(completeUrl)")
//        print("Parameters: \(parameters)")
//        print("Headers: \(token)")
//        
//        request.httpBody = jsonData
//        print("\(APIs.json(from: parameters)))")
//        if let vc = viewController {
//            vc.showActivityIndicator2()
//        }
//        
//        AF.request(request).responseJSON { response in
//            print("Response: \(response)")
//            if let vc = viewController {
//                vc.hideActivityIndicator2()
//            }
//            switch response.result {
//            case .success(let json):
//                let modelGetActiveLoan = try? JSONDecoder().decode(NanoLoanApplyViewController.ModelGetLoanCharges.self, from: response.data!)
//                print(modelGetActiveLoan)
//                
//                let serverResponse = JSON(response.value!)
//                
//                print("Request Headers: \(String(describing: request.allHTTPHeaderFields))")
//                print("Request Url: \(String(describing: request.url))")
//                print("Request Parameters: \(parameters)")
//                print("JSON: \(serverResponse)")
//                print("JSON: \(json)")
//                switch response.response?.statusCode {
//                case 200 :
//                    if serverResponse["responsecode"] == 1 {
//                        completion(response.data, true, "")
//                    }
//                    else {
//                        completion(response.data, false, serverResponse["message"].string ?? "")
//                    }
//                    break
//                default :
//                    completion(response.data, false, serverResponse["message"].string ?? "")
//                    break
//                }
//            case .failure( _):
//                var errorMessage = ""
//                if let error = response.error?.localizedDescription {
//                    let errorArray = error.components(separatedBy: ":")
//                    errorMessage = errorArray.count > 1 ? errorArray[1] : error
//                    completion(nil, false, errorMessage)
//                }
//                else {
//                    errorMessage = response.error.debugDescription
//                    completion(nil, false, response.error.debugDescription)
//                }
//                break
//            }
//        }
//    }
    
    
    static func postAPI(apiName: APIsName.name, parameters: [String: Any], headerWithToken: String? = nil, httpMethod: HTTPMethod? = .post , headers: HTTPHeaders? = nil, viewController: UIViewController? = nil, completion: @escaping(_ response: Data?, Bool, _ errorMsg: String) -> Void) {
        
//        let stringParamters = APIs.json(from: params)
        //let postData = stringParamters!.data(using: .utf8)

        let completeUrl = APIPath.baseUrl + apiName.rawValue
        
        let url = URL(string: completeUrl)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if kAccessToken != "" {
            let authToken = "bearer \(kAccessToken)"
            request.addValue(authToken, forHTTPHeaderField: "Authorization")
        }
       
        
        print("Url: \(completeUrl)")
        print("Parameters: \(parameters)")
        print("Headers: \(kAccessToken)")
        
//        request.httpBody = jsonData
        //print("\(APIs.json(from: parameters)))")
        if let vc = viewController {
            vc.showActivityIndicator2()
        }
        
        AF.request(request.url!, method: httpMethod!, parameters: parameters, encoding:JSONEncoding.default, headers: request.headers)
                    .responseData { response in
//           guard let data = response.data else { return }
//           let json = try? JSON(data:data)
//           if let acc = json?["Account"].string {
//             print(acc)
//           }
//           if let pass = json?["Password"].string {
//             print(pass)
//           }
//        }
//
            print("Response: \(response)")
            if let vc = viewController {
                vc.hideActivityIndicator2()
            }
   
            var responseMessage = ""
            if let jsonObject = dataToJsonString(data: response.data ?? Data()) {
                print("API Response jsonObject: \(jsonObject)")
                print("jsonResponse: \(jsonObject)")
                responseMessage = jsonObject["message"] as? String ?? ""
            }
            if let jsonString = response.data?.prettyPrintedJSONString {
                print("API Response jsonObject PrettyPrintedJSONString: \(jsonString)")
                print("jsonResponse: \(jsonString)")
            }
            
            switch response.result {
            case .success(let json):
                print("Request Headers: \(String(describing: request.allHTTPHeaderFields))")
                print("Request Url: \(String(describing: request.url))")
                print("Request Parameters: \(parameters)")
//                print("JSON: \(serverResponse)")
                print("JSON: \(json)")
                switch response.response?.statusCode {
                case 200 :
                    completion(response.data, true, "")
                    break
                default :
                    completion(response.data, false, responseMessage)
                    break
                }
            case .failure( _):
                var errorMessage = ""
                if let error = response.error?.localizedDescription {
                    let errorArray = error.components(separatedBy: ":")
                    errorMessage = errorArray.count > 1 ? errorArray[1] : error
                    completion(nil, false, errorMessage)
                }
                else {
                    errorMessage = response.error.debugDescription
                    completion(nil, false, response.error.debugDescription)
                }
                break
            }
        }
    }
    
    static func postAPI2(apiName: APIsName.name, parameters: [String: Any], headerWithToken: String? = nil , headers: HTTPHeaders? = nil, viewController: UIViewController? = nil, completion: @escaping(_ response: Data?, Bool, _ errorMsg: String) -> Void) {
        
//        let stringParamters = APIs.json(from: params)
        //let postData = stringParamters!.data(using: .utf8)

        let completeUrl = APIPath.baseUrl + apiName.rawValue
        
        let url = URL(string: completeUrl)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let authToken = "bearer \(kAccessToken)"

        
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var tempHeader = ""
        var token  = ""
        
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        //
        
        print("Url: \(completeUrl)")
        print("Parameters: \(parameters)")
        print("Headers: \(token)")
        
//        request.httpBody = jsonData
        //print("\(APIs.json(from: parameters)))")
        if let vc = viewController {
            vc.showActivityIndicator2()
        }
        
        AF.request(request.url!, method: .get, parameters: parameters, encoding:URLEncoding.default, headers: request.headers)
                    .responseData { response in
//           guard let data = response.data else { return }
//           let json = try? JSON(data:data)
//           if let acc = json?["Account"].string {
//             print(acc)
//           }
//           if let pass = json?["Password"].string {
//             print(pass)
//           }
//        }
//
            print("Response: \(response)")
            if let vc = viewController {
                vc.hideActivityIndicator2()
            }
   
            var responseMessage = ""
            if let jsonObject = dataToJsonString(data: response.data ?? Data()) {
                print("API Response jsonObject: \(jsonObject)")
                print("jsonResponse: \(jsonObject)")
                responseMessage = jsonObject["message"] as? String ?? ""
            }
            if let jsonString = response.data?.prettyPrintedJSONString {
                print("API Response jsonObject PrettyPrintedJSONString: \(jsonString)")
                print("jsonResponse: \(jsonString)")
            }
            
            switch response.result {
            case .success(let json):
                print("Request Headers: \(String(describing: request.allHTTPHeaderFields))")
                print("Request Url: \(String(describing: request.url))")
                print("Request Parameters: \(parameters)")
//                print("JSON: \(serverResponse)")
                print("JSON: \(json)")
                switch response.response?.statusCode {
                case 200 :
                    completion(response.data, true, "")
                    break
                default :
                    completion(response.data, false, responseMessage)
                    break
                }
            case .failure( _):
                var errorMessage = ""
                if let error = response.error?.localizedDescription {
                    let errorArray = error.components(separatedBy: ":")
                    errorMessage = errorArray.count > 1 ? errorArray[1] : error
                    completion(nil, false, errorMessage)
                }
                else {
                    errorMessage = response.error.debugDescription
                    completion(nil, false, response.error.debugDescription)
                }
                break
            }
        }
    }
    
    /*
    static func uploadFile<T: Codable>(apiName: APIs.name, fileData:Data, fileName:String, parameters: [String: AnyObject], viewController: UIViewController? = nil, modelType: T.Type, completion: @escaping(_ T: Codable?, Bool, _ errorMsg: String) -> Void) {
        // params to send additional data, for eg. AccessToken or userUserId
        let completeUrl = APIPath.baseUrl + apiName.rawValue
        let parameterJsonString = parameters.toJSONString()
        
        let baseClass = BaseClassVC()
        let result = (baseClass.splitString(stringToSplit: baseClass.base64EncodedString(params: parameters)))
        
        let paramstemp = [
            "apiAttribute1":result.apiAttribute1,
            "apiAttribute2":result.apiAttribute2,
            "channelId":"\(DataManager.instance.channelID)"
        ]
        let stringParamters = APIs.json(from: paramstemp)
        
        let params = ["data": stringParamters]
        print(params)
        
        //let postData = stringParamters!.data(using: .utf8)
        let url = URL(string: completeUrl)!
//        let jsonData = stringParamters!.data(using: .utf8, allowLossyConversion: false)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
                
        var token = DataManager.instance.accessToken ?? ""
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let headers: HTTPHeaders = [
                    "Authorization": "\(token)", // in case you need authorization header
                    "Content-type": "multipart/form-data"
                ]
        
        print("Url: \(completeUrl)")
        print("Parameters: \(parameters)")
        print("Headers: \(token)")
        
//        request.httpBody = jsonData
        //print("\(APIs.json(from: parameters)))")
        if let vc = viewController {
            vc.showActivityIndicator2()
        }
        
        AF.upload(multipartFormData: { multiPart in
            multiPart.append(fileData,
                             withName: "file",
                             fileName: "\(fileName)",
                             mimeType: "image/jpeg/jpg/png")
            
            for (key,keyValue) in params{
                if let keyData = keyValue!.data(using: .utf8){
                    multiPart.append(keyData, withName: key)
                }
            }
        }, to: completeUrl, method: .post, headers: headers).responseDecodable(of: T.self) { apiResponse in
            //       .responseJSON { apiResponse in
            if let vc = viewController {
                vc.hideActivityIndicator2()
            }
            
            switch apiResponse.result{
            case .success(_):
                let apiDictionary = apiResponse.value as? [String:Any]
                print("apiResponse --- \(apiDictionary)")
                print("apiResponse --- \(apiResponse)")
                completion(apiResponse.value, true, "")
            case .failure(_):
                print("got an error")
                completion(apiResponse.value, false, "error in model")
            }
        }
    }
     */
    
    static func dataToJsonString(data: Data) -> [String : Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            return json
        } catch {
            print("errorMsg")
        }
        return ["error" : "errorMsg"]
    }
    
    static func decodeDataToObject<T: Codable>(data : Data?)->T?{
        if let dt = data{
            do{
                return try JSONDecoder().decode(T.self, from: dt)
                
            }  catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        return nil
    }
    
    
    /*
    
    //Working Code with URLSession Request
    static func downloadFileFromURLSessionRequest(URL: NSURL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL as URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")

                // This is your file-variable:
                // data
            }
            else {
                // Failure
                print("Failure: %@", error.localizedDescription);
            }
        })
        task.resume()
    }
     */

    
    
    func isValidEmail(testStr:String) -> Bool {
        
//        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
        
    }
}
extension Dictionary {
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
    
    func toJSONString() -> String? {
        if let jsonData = jsonData {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        
        return nil
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject,
                                                       options: [.prettyPrinted]),
              let prettyJSON = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                  return nil
               }

        return prettyJSON
    }
    func jsonToString(json: AnyObject){
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: .utf8) // the data will be converted to the string
                print(convertedString) // <-- here is ur string
                
            } catch let myJSONError {
                print(myJSONError)
            }
          
        }
}


