import PackageDescription

let package = Package(
    name: "Lambda",
    dependencies: [
        .Package(url: "https://github.com/choefele/AlexaSkillsKit", majorVersion: 0)
    ])
