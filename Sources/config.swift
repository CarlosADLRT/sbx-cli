import Foundation
import Guaka
import FileUtils


var configCommand = Command(
        usage: "config", configuration: configuration, run: execute)


private func configuration(command: Command) {

    command.add(flags: [

            // Add your flags here
            Flag(shortName: "l", longName: "login", type: String.self, description: "The email of the user to authenticate", required: true)
    ]
    )

    // Other configurations
}

private func execute(flags: Flags, args: [String]) {

    let semaphore = DispatchSemaphore(value: 1)

    guard let login = flags.getString(name: "login") else {
        print("invalid login")
        return
    }

    print("Please enter your password for sbxcloud.com:")

    guard let pwd = readLine(), !pwd.isEmpty else {
        print("Invalid password provided.")
        return
    }

    semaphore.wait()


    doLogIn(login, password: pwd) {
        (error: Error?, response: SbxSession?) in
        print("good? \(error)")

        semaphore.signal()
    }

    semaphore.wait()
}


private func doLogIn(_ email: String, password: String, cb: @escaping ((Error?, SbxSession?) -> ())) {

    let session = URLSession(configuration: .ephemeral)

    var urlComponents = URLComponents(string: "https://sbxcloud.com/api/user/v1/login")
    urlComponents!.queryItems = [URLQueryItem(name: "login", value: email), URLQueryItem(name: "password", value: password)]

    print(urlComponents!.string!)

    var request = URLRequest(url: URL(string: urlComponents!.string!)!)  // inspect with Show Result button

    request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    request.networkServiceType = .default
    request.addValue("application/json", forHTTPHeaderField: "content-type")
    request.addValue("f4f4fa3455-123b-bcd2-fed67-bcd8765", forHTTPHeaderField: "App-Key")


    let taskWithRequest = session.dataTask(with: request) { (data: Data?, response: URLResponse?, e: Error?) -> Void in

        do {

            guard
                    let dataString = String(data: data!, encoding: .utf8),
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                    let success = parsedData["success"] as? Bool,
                    success == true,
                    let token = parsedData["token"] as? String
                    else {
                return cb(SbxError.authenticationError, nil)
            }
            print("\(dataString)")

            try File.write(string: dataString, toPath: "\(Path.home)/.sbx")

            // we have a token, let it go
            sbxSession.updateToken(token: token)

            cb(e, nil)
        } catch {
            cb(error, nil)
        }


    }



    taskWithRequest.resume()
}


enum SbxError: Error {
    case authenticationError
    case findError
}
