import PackageDescription

let package = Package(
        name: "sbx",
        dependencies: [
                .Package(url: "https://github.com/oarrabi/Guaka.git", majorVersion: 0),
                .Package(url: "https://github.com/oarrabi/FileUtils.git", majorVersion: 0)
        ]
)
