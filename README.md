(Under development)

# y2p

This is CLI application which generate screen trantision diagram based on some yaml file.

<img width="889" alt="test" src="https://user-images.githubusercontent.com/16571394/233756870-0ea48565-1b16-43e4-8384-1d8a95f052ce.jpg">

You can check the actual generated svgs from the [Sample folder](https://github.com/takeshi-1000/y2p/tree/main/Sample).

This tool is specifically designed for the screen transition of mobile applications, so that a diagram is generated that covers screens that are transitioned from a single root screen.

## How to use

- git clone this repository
- cd this repository
- swift build
- ./.build/debug/y2p
  - When executing this command, you need to have the "y2p.yaml" file in the directory where the command is being executed.
  
## Options

- `-fileName`: specific yaml file which you like (e.g `./.build/debug/y2p -fileName test.yaml`)
- `-o`: output fileName, default is `screen_transition_diagram.svg`. (e.g `./.build/debug/y2p -o test.svg`)
- `-d` or `-dump`: dump svg text (this is only for svg, and now even if you add this option, svg file is created)
  
## Attributions

This tool is powered by:

- [YamlSwift](https://github.com/behrang/YamlSwift)

Inspiration for this tool came from:

- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Contributions

Contributions are always welcome. Please create an issue or pull request as needed.

## Licence

Licensed under the MIT license
