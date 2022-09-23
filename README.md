[![iOS Workflow](https://github.com/OccamsCode/SampleCode/actions/workflows/CI.yml/badge.svg)](https://github.com/OccamsCode/SampleCode/actions/workflows/CI.yml)

# Sample Code

Hi! Chances are you found yourself here because you asked to see some sample code from me

## What to expect

In this repository, you can expect to find;

 - **Model View ViewModel Pattern** - Out of all the patterns out there at the moment I find MVVM to be the most fun to use. MVC is useful for rapid prototypes & V.I.P.E.R. is overkill much for something this simple. Keep note this is MVVM without the use of data bindings, that will be separate project 
 - **Coordinators** - I find the coordinator pattern very useful when trying to follow the Single Responsible Principle.
 - **Protocol Orientated Programming** - I prefer using POP over OOP as it allows for better testability.  There are areas where classes can be abstracted however I feel it's best to do so when said class is going to be used in multiple places.
 - **Other Patterns** - On top the aforementioned patterns, I've included other patterns I enjoy working with such as;
     - Factory Pattern
     - Dependency Injection 
     - Delegation
     - Observer/Notifications
     - Extensions
 - **No 3rd Frameworks** - I purposely stayed away from using CocoaPods, Carthage and Swift Package Manager. I feel it's more important to display my knowledge of the underlying frameworks instead displaying which popular ones I am aware of
 - **Unit Testing** - I'm a big proponent of unit testing, hence it's inclusion here. With the patterns and ideas I have in place it's fairly easy to test everything apart the Views. Currently I'm attempting to sustain over 65% code coverage
 - **Cool Features** - I always love implementing cool features in sample projects, this one you will find
     - Context Menus (previously known as Peek with 3D touch)
     - Safari View Controller
     - Smoothing Scrolling

## Building & Running

As this project does not use any framework management tools, you should be able to;

 - Clone the repository
 - Open using an up-to date version of Xcode (preferably versions 12+)
 - Target any iPhone/iPod Touch device and run

## Things to Improve

Needless to say this code is not perfect, things that can (and should) be improved include;

 - [ ] Full Dark Mode support
 - [ ] Full Dynamic Font support
 - [ ] Voice Over support
 - [ ] Consistent & clear naming 
 - [ ] Localisation of static text
 - [ ] Image Caching 
 - [ ] Banishing magic strings and numbers 
 - [ ] Proper/Usable support for iPad devices

### Small/Final Note
This repository is a continual work in progress and will be constantly updated with with ideas and patterns I like the sound of. 
With that being said, chances are this project can (and mostly will) never be truly completed. Then again what software is ever finished?
