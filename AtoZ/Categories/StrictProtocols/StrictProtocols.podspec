Pod::Spec.new do |s|
  #  Be sure to run `pod spec lint StrictProtocols.podspec' to ensure this is a
  #  valid spec and to remove all comments including this before submitting the spec.
  #  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
  #  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.

  s.name         = "StrictProtocols"
  s.version      = "1.0.0"
  s.summary      = "Check class' ACTUAL conformance to a <Protocol>'s @required or @requqired + @optional methods."

  s.description  = <<-DESC
                   A longer description of StrictProtocols in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/mralexgray/StrictProtocols"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #
  s.license      = { :type => 'zlib', :file => 'LICENSE.StrictProtocols.md' }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors by using the SCM log. E.g. $ git log. If no email can be
  #  found CocoaPods accept just the names.

  s.author       = { "Alex Gray" => "alex@mrgray.com" }
  # s.authors      = { "Alex Gray" => "alex@mrgray.com", "other author" => "email@address.com" }
  # s.author       = 'Alex Gray', 'other author'

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.

  # s.platform     = :ios
  # s.platform     = :ios, '5.0'

  #  When using multiple platforms
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, svn and HTTP.

  s.source       = { :git => "https://github.com/mralexgray/StrictProtocols.git", :tag => "1.0.0" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  CocoaPods is smart about how it include source code, for source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.

  s.source_files  = 'StrictProtocols.*'
  # s.exclude_files = 'Classes/Exclude'
  # s.public_header_files = 'NSObject+StrictProtocols.h'
  # s.public_header_files = 'Classes/**/*.h'

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  
  # s.framework  = 'SomeFramework'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  # s.dependency 'JSONKit', '~> 1.4'

end