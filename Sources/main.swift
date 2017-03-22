import Guaka

setupCommands()


struct SbxSession {

    var token: String?

    mutating func updateToken(token: String) {
        self.token = token
    }

}

var sbxSession = SbxSession()

rootCommand.execute()
