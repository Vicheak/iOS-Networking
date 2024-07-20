//
//  APIService.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 7/7/24.
//

import UIKit
import NVActivityIndicatorView

struct ResponseData: Decodable {
    var message: String
    var status: Int
    var data: ResponseDetail
}

struct ResponseDetail: Decodable {
    var jwt: JWTDetail?
    var message: String?
    var email: [String]?
    var password: [String]?
    var forgetPassword: ForgetPassword?
    
    enum CodingKeys: String, CodingKey {
        case jwt
        case message
        case email
        case password
        case forgetPassword = "forgot_password"
    }
}

struct JWTDetail: Decodable {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

struct ForgetPassword: Decodable {
    var message: String
    var expiresAt: Date
    var passwordToken: String
    var otpCode: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case expiresAt = "expires_at"
        case passwordToken = "password_token"
        case otpCode = "otp_code"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        passwordToken = try container.decode(String.self, forKey: .passwordToken)
        otpCode = try container.decode(String.self, forKey: .otpCode)
        let getExpiresAt = try container.decode(String.self, forKey: .expiresAt)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        expiresAt = dateFormatter.date(from: getExpiresAt)!
    }
}

class APIService {
    
    static let shared = APIService()
    
    func login(indicatorView: NVActivityIndicatorView, withUsername username: String, withPassword password: String, completion: @escaping (Bool, String, String?) -> Void) {
        let url = URL(string: "https://api.dev.nengnong.camsolutiondemo.com/api/v1/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let bodyData = ["email": username.lowercased(), "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
        
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
          
            //validate http request
            if !validateRequest(indicatorView: indicatorView, data: data, response: response, error: error, completion: completion) {
                return //return here when fail to get response from server
            }
            
            do {
                let responseData = try JSONDecoder().decode(ResponseData.self, from: data!)
                print(responseData)
                
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                        //pass access token to the login screen callback function
                        completion(true, responseData.message, responseData.data.jwt?.accessToken)
                    }
                } else if httpResponse.statusCode == 400 || httpResponse.statusCode == 422 {
                    if let message = responseData.data.message {
                        //invalid credential
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message, "")
                        }
                    } else if let message = responseData.data.email {
                        //not a valid email address
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message.first ?? "email is not valid!", "")
                        }
                    } else if let message = responseData.data.password {
                        //password must be 8 chars
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message.first ?? "password must be 8 chars!", "")
                        }
                    }
                }
            } catch let decodingError {
                print(decodingError)
            }
        }
        task.resume()
        //loading
        indicatorView.startAnimating()
    }
    
    func register(indicatorView: NVActivityIndicatorView, withFullname fullname: String, withEmail email: String, withPassword password: String, completion: @escaping (Bool, String, String?) -> Void) {
        let url = URL(string: "https://api.dev.nengnong.camsolutiondemo.com/api/v1/auth/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = ["full_name": fullname, "email": email.lowercased(), "password": password, "password_confirmation": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
        
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
          
            //validate http request
            if !validateRequest(indicatorView: indicatorView, data: data, response: response, error: error, completion: completion) {
                return //return here when fail to get response from server
            }
            
            do {
                let responseData = try JSONDecoder().decode(ResponseData.self, from: data!)
                print(responseData)
                
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                        completion(true, responseData.data.message!, "")
                    }
                } else if httpResponse.statusCode == 422 {
                    if let message = responseData.data.email {
                        //not a valid email address
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message.first ?? "email is not valid!", "")
                        }
                    } else if let message = responseData.data.password {
                        //password is not valid or cannot be processible!
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message.first ?? "password is not valid or cannot be processible!", "")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                    }
                }
            } catch let decodingError {
                print(decodingError)
            }
        }
        task.resume()
        //loading
        indicatorView.startAnimating()
    }
    
    func verifyCode(indicatorView: NVActivityIndicatorView, withEmail email: String, withOtpCode otpCode: String, completion: @escaping (Bool, String, String?) -> Void) {
        let url = URL(string: "https://api.dev.nengnong.camsolutiondemo.com/api/v1/auth/verify")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = ["email": email.lowercased(), "otp_code": otpCode]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
        
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
          
            //validate http request
            if !validateRequest(indicatorView: indicatorView, data: data, response: response, error: error, completion: completion) {
                return //return here when fail to get response from server
            }
            
            do {
                let responseData = try JSONDecoder().decode(ResponseData.self, from: data!)
                print(responseData)
                
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                        completion(true, responseData.data.message!, "")
                    }
                } else if httpResponse.statusCode == 400 || httpResponse.statusCode == 422 {
                    if let message = responseData.data.message {
                        //invalid OTP Code
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message, "")
                        }
                    } else if let message = responseData.data.email {
                        //not a valid email address
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message.first ?? "email is not valid!", "")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                    }
                }
            } catch let decodingError {
                print(decodingError)
            }
        }
        task.resume()
        //loading
        indicatorView.startAnimating()
    }
    
    func resendCode(indicatorView: NVActivityIndicatorView, withEmail email: String, completion: @escaping (Bool, String, String?) -> Void) {
        let url = URL(string: "https://api.dev.nengnong.camsolutiondemo.com/api/v1/auth/resend")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = ["email": email.lowercased()]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
        
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
          
            //validate http request
            if !validateRequest(indicatorView: indicatorView, data: data, response: response, error: error, completion: completion) {
                return //return here when fail to get response from server
            }
            
            do {
                let responseData = try JSONDecoder().decode(ResponseData.self, from: data!)
                print(responseData)
                
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                        completion(true, responseData.data.message!, "")
                    }
                } else if httpResponse.statusCode == 400 || httpResponse.statusCode == 422 {
                    if let message = responseData.data.message {
                        //OTP Code not expired yet
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message, "")
                        }
                    } else if let message = responseData.data.email {
                        //not a valid email address
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message.first ?? "email is not valid!", "")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                    }
                }
            } catch let decodingError {
                print(decodingError)
            }
        }
        task.resume()
        //loading
        indicatorView.startAnimating()
    }
    
    func forgetPassword(indicatorView: NVActivityIndicatorView, withEmail email: String, completion: @escaping (Bool, String, String?) -> Void) {
        let url = URL(string: "https://api.dev.nengnong.camsolutiondemo.com/api/v1/auth/forgot-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = ["email": email.lowercased()]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
        
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
          
            //validate http request
            if !validateRequest(indicatorView: indicatorView, data: data, response: response, error: error, completion: completion) {
                return //return here when fail to get response from server
            }
            
            do {
                let responseData = try JSONDecoder().decode(ResponseData.self, from: data!)
                print(responseData)
                
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                    
                        //access to forgetPassword object
                        let forgetPassword = responseData.data.forgetPassword!
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        //extract OTP Code
//                        if let range = forgetPassword.otpCode.range(of: "^[0-9]{4}", options: .regularExpression) {
//                            let otpCode = String(forgetPassword.otpCode[range])
//                            completion(true, forgetPassword.message + ", it will expire at " + dateFormatter.string(from: forgetPassword.expiresAt), otpCode)
//                        } else {
//                            completion(false, "There is such error at the server!", "")
//                        }
                        
                        completion(true, forgetPassword.message + ", it will expire at " + dateFormatter.string(from: forgetPassword.expiresAt), forgetPassword.passwordToken)
                    }
                } else if httpResponse.statusCode == 400 || httpResponse.statusCode == 422 {
                    if let message = responseData.data.message {
                        //already requested OTP code
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message, "")
                        }
                    } else if let message = responseData.data.email {
                        //not a valid email address
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message.first ?? "email is not valid!", "")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                    }
                }
            } catch let decodingError {
                print(decodingError)
            }
        }
        task.resume()
        //loading
        indicatorView.startAnimating()
    }
    
    func resetPassword(indicatorView: NVActivityIndicatorView, withPassword password: String, withPasswordToken token: String, completion: @escaping (Bool, String, String?) -> Void) {
        let url = URL(string: "https://api.dev.nengnong.camsolutiondemo.com/api/v1/auth/reset-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = ["password": password, "password_confirmation": password, "password_token": token]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
        
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            //validate http request
            if !validateRequest(indicatorView: indicatorView, data: data, response: response, error: error, completion: completion) {
                return //return here when fail to get response from server
            }
            
            do {
                let responseData = try JSONDecoder().decode(ResponseData.self, from: data!)
                print(responseData)
                
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                        completion(true, responseData.data.message!, "")
                    }
                } else if httpResponse.statusCode == 400 {
                    if let message = responseData.data.message {
                        //Invalid password token
                        DispatchQueue.main.async {
                            indicatorView.stopAnimating()
                            completion(false, message, "")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                    }
                }
            } catch let decodingError {
                print(decodingError)
            }
        }
        task.resume()
        //loading
        indicatorView.startAnimating()
    }
    
    func validateRequest(indicatorView: NVActivityIndicatorView, data: Data?, response: URLResponse?, error: (any Error)?, completion: @escaping (Bool, String, String?) -> Void) -> Bool {
        if let error = error {
            print(error)
            DispatchQueue.main.async {
                indicatorView.stopAnimating()
                completion(false, "Internet connection failed!", "")
            }
            return false
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Cannot get response from server!")
            DispatchQueue.main.async {
                indicatorView.stopAnimating()
                completion(false, "Cannot get response from server!", "")
            }
            return false
        }
        print(httpResponse.statusCode)
        guard let _ = data else {
            print("Cannot get data from server!")
            DispatchQueue.main.async {
                indicatorView.stopAnimating()
                completion(false, "Cannot get data from server!", "")
            }
            return false
        }
        return true
    }
    
    //user service
    
    
}
