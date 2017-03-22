import Guaka

var initCommand = Command(
        usage: "init", configuration: configuration, run: execute)


private func configuration(command: Command) {

    command.add(flags: [
            // Add your flags here
    ]
    )

    // Other configurations
}

private func execute(flags: Flags, args: [String]) {
    // Execute code here
    print("init called")
}
