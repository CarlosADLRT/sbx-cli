import Guaka

// Generated, dont update
func setupCommands() {
    rootCommand.add(subCommand: contentCommand)
    rootCommand.add(subCommand: configCommand)
    contentCommand.add(subCommand: pushCommand)
    contentCommand.add(subCommand: linkCommand)
    rootCommand.add(subCommand: initCommand)
    // Command adding placeholder, edit this line
}
