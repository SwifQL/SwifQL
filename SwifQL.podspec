
Pod::Spec.new do |spec|

    spec.name         = "SwifQL"
    spec.version      = "2.1.0"

    spec.summary      = "Super flexibel SQL query builder for server-side Swift"
    spec.description  = """
    This lib can be used either stand alone, or with frameworks like Vapor, Kitura, Perfect and others

    We recommend to use it with our Bridges lib which is built on top of SwifQL and support all its flexibility

    It supports PostgreSQL and MySQL. And it's not so hard to add other dialects 🙂 just check SwifQL/Dialect folder
    """


    spec.homepage = "https://github.com/SwifQL/SwifQL"
    spec.author = { "MihaelIsaev" => "isaev.mihael@gmail.com" }
    spec.license = { :type => "MIT", :file => "LICENSE" }

    spec.swift_version = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5']
    # spec.platform = :osx, :ios
    spec.source = { :git => "git@github.com:SwifQL/SwifQL.git", :tag => spec.version.to_s }
    spec.source_files  = "Sources/SwifQL/**/*.swift"

    end