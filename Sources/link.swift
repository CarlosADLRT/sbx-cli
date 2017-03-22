import Guaka

var linkCommand = Command(
        usage: "link", configuration: configuration, run: execute)


private func configuration(command: Command) {

    command.add(flags: [
            // Add your flags here
    ]
    )

    // Other configurations
}

private func execute(flags: Flags, args: [String]) {
    // Execute code here
    print("link called")
}
