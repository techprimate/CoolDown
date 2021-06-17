//
//  ContentView.swift
//  CoolDownExample
//
//  Created by Philip Niedertscheider on 17.06.21.
//

import SwiftUI
import CoolDownParser
import CoolDownSwiftUIMapper

struct ContentView: View {

    let text = """
    Styling a view is the most important part of building beautiful user interfaces. When it comes to the actual code syntax, we want reusable, customizable and clean solutions in our code.

    This article will show you these 3 ways of styling a `SwiftUI.View`:

    1.  Initializer-based configuration
    2.  Method chaining using return-self
    3.  Styles in the Environment

    As a general rule of thumb, any approach is viable. In the end, it comes down to your general code-style guidelines and personal preferences.

    ![](https://miro.medium.com/max/7480/1\\*4Kk\\_v9ER65tuYvoK0aCeIw.png "The property wrapper you will find in chapter 3 \"Styles in Environment\"")

    # 1. Initializer-based configuration

    This is one is straight forward and can be visualized with an example rather quickly:

    [](https://gist.github.com/philprime/1f5663bddd4dacd3bb9c73e1cb9b9436/raw/61f4744373ca88d772f48ebb89dd21a2ac0828d4/ways-of-SwifUI-styling-01.swift)

    This view takes two parameters `backgroundColor` and `textColor`, which are both required when instantiating the struct. They are also both constant `let` values, as the view most likely isn’t going to be mutated (at this point).

    Conveniently Swift automatically synthesizes the (internal) required initializer, but they can also manually be defined be us:

    [](https://gist.github.com/philprime/ea39f38b24d6172e67242a255ab87419/raw/4a55cf1420c8d6570fb3a7b059df96606a6bca1c/ways-of-SwifUI-styling-02.swift)

    > **Quick Tip:**
    > Xcode also provides us with a built-in function to generate memberwise initializers. All you have to do is `CMD(⌘) + left-click` on the type name, and select the action.

    ![](https://miro.medium.com/max/2872/1\\*NptvXt3t8gt4Ay\\_MDhHIgg.png "Xcode can automatically generate memberwise initializers")

    Using a custom initializer allows us to add default values directly there without changing the `let` of the parameters to `var` ones:

    [](https://gist.github.com/philprime/8752c59723785dcf517a4aa28312e8f1/raw/a0fbe109d7abeee601a2a46d67c1ecb4296a9ab2/ways-of-SwifUI-styling-03.swift)

    As mentioned before, Swift synthesizes only internal initializers, so in case your view is part of a package and needs to be `public`, you are required to use this approach. Otherwise the application using the package won’t be able to find or instantiate the view.

    On the other hand, if this view is only used inside your app, you can also let the Swift compiler do the work for you 🚀 All that is needed is changing from `let` to `var` and directly set the default values on the instance properties:

    [](https://gist.github.com/philprime/784cdb430a83857c9ecdf9d1c8957dff/raw/e22b2d0e9ee4861710b1f9809d426c50e3f9e4c5/ways-of-SwifUI-styling-04.swift)

    # 2. Method chaining using Return-Self

    Your views keep growing and requires more parameters to be set. As the initializer keeps growing too, it eventually becomes a large piece of code.

    [](https://gist.github.com/philprime/b49115816e6c3de8e12262b9da19e249/raw/144987d9c4a3f773352958ea9f10f47c9ea789a0/ways-of-SwifUI-styling-05.swift)

    However, from my personal experience at some point the Swift compiler has too much work to do at the same time and simply gives up (it crashes).

    One approach of breaking down large initializers (with default values) is using a return-self-chaining pattern:

    [](https://gist.github.com/philprime/32febb595f436dfa8f05e41669dbe236/raw/336e6151ed24b4a195484fd600d202bfb585a6f9/ways-of-SwifUI-styling-06.swift)

    As the view itself is immutable, but consists out of pure data (structs are not objects), we can create a local copy with `var view = self`. As this is now a local variable, we can mutate it and set the action, before returning it.

    # 3. Styles in the Environment

    Apart from manually configuring every single view we can define a global style guide. An example might look like the following:

    [](https://gist.github.com/philprime/2d266fa8589414377708703426e7c4a2/raw/138f5ecc1162582be4375e778d104f2e16130f7a/ways-of-SwifUI-styling-07.swift)

    Unfortunately, this solution has a big issue:
    Global static variables means, they are not customizable for different use cases (for example in an Xcode preview) 😕

    Our solution is opting in for instance configuration once again:

    [](https://gist.github.com/philprime/e0c5fbe4d2d9cc499834d337ee4fcd3c/raw/0e91186a4928dfde8a5ec3e974076e251008ab1c/ways-of-SwifUI-styling-08.swift)

    This looks promising, as we can now pass the style configuration into the view from where-ever we need it:

    [](https://gist.github.com/philprime/eb1a4528a4e453fc2be79e7f7d4aa1e7/raw/3aa633f9c4aef04318c909eddfd9769de7c10e28/ways-of-SwifUI-styling-09.swift)

    Quite a clean solution. But you might already be wondering “But wait! How is this a **global** solution?” and your doubts are justified! This solution requires us to pass the style down to every single view, just as in the following code snippet:

    [](https://gist.github.com/philprime/6cdab7295fb2ddf3c91fa77d756d9d6e/raw/b72b5899d0e178010cb6e49d66670ad7ae51cd40/ways-of-SwifUI-styling-10.swift)

    It took three passes just to get the “global” style object into the nested `FooBar` view. This is unacceptable. We don’t want this much unnecessary code (especially because you also strive for clean code, don’t you?).

    Okay so what else could we think off? Well, how about a mix between the static and the instance solution?
    All we need is a static object where we can set the style from `Foo` and read it from `FooBar` … sounds like some shared _environment_💡

    SwiftUI introduced the property wrapper [`@Environment`](https://developer.apple.com/documentation/swiftui/environment) which allows us to read a value from the shared environment of our view🥳

    As a first step, create a new `EnvironmentKey` by creating a struct implementing the `defaultValue`:

    [](https://gist.github.com/philprime/c1c6126ab10cb08eeae505026d5997a4/raw/504fb02aa17c2be80ff5d1fb0424d223b5e08f91/ways-of-SwifUI-styling-11.swift)

    Next you need to add the new environment key as an extension to the `EnvironmentValues` so it can be accessed from the property wrapper:

    [](https://gist.github.com/philprime/a0a38331d83486fab43d9d63a74248a2/raw/11bdffbfdc4c3d00e734a1ab66515c4a899ac845/ways-of-SwifUI-styling-12.swift)

    Finally set the value using `.environment(\\.style, ...)` in the root view and read the value using the keypath of the `style` in`@Environment(\\.style)` in the child views:

    [](https://gist.github.com/philprime/bfb44364fcac67291198d67ae3a69976/raw/04c900a70316ebc5f6fceb79880e97f5d40856c6/ways-of-SwifUI-styling-13.swift)

    Awesome! No more unnecessary instance passing and still configurable from the root view 🚀

    ---

    ## **Bonus: Custom Property Wrapper**

    Our environment solution is already working pretty nice, but isn’t the following even cleaner?

    [](https://gist.github.com/philprime/a3d77a9e80ffacf5df28d074511e0734/raw/a0203f0c01cb3ebfa50a54753d51628133d3a3bc/ways-of-SwifUI-styling-14.swift)

    All you need for this beautiful syntax is creating a custom property wrapper `@Theme` which wraps our environment configuration and accesses the style value by a keypath.

    [](https://gist.github.com/philprime/b15857263fc208d9b0d093c403c6a057/raw/0310b047decf3a2f6ceb368bdb2b17fadc07f5e7/ways-of-SwifUI-styling-15.swift)

    Even better, using a `View` extension allows us to hide the usage of `Environment` entirely!

    [](https://gist.github.com/philprime/cd236aacf241015f68ffab7a785fc7fd/raw/c357fd829ad9bb67cfdd62eb44c2b7bd7033319c/ways-of-SwifUI-styling-16.swift)

    > **Note:** The reason the style is now called `theme` is quite honestly just a naming conflict of a property wrapper `@Style` with the `struct Style`. If you rename the style structure you can also use this name for the property wrapper.

    # Conclusion

    SwiftUI offers multiple different ways of building our view hierarchy, and we explored just a few of them. Additional options such as e.g. `ViewModifier` already exist, and even more will surface in the future.

    At the time of writing **best** practices don’t really exist yet, as the technology is still quite new. Instead we have different **good** practices to choose from and can focus on re-usability, customizability and cleanness of our code.

    If you would like to know more, checkout my other articles, follow me on [Twitter](https://twitter.com/philprimes) and feel free to drop me a DM.
    You have a specific topic you want me to cover? Let me know! 😃
    """

    var body: some View {
        ScrollView {
            CDMarkdownView(text: text, mapper: .default)
                .useCache()
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
