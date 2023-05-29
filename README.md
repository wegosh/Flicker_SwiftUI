# Flicker_SwiftUI

## SPM packages used:
> [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) - Used to show images from URL as alternative to AsyncImage. The reason behind this is actually ability to cache image data.

## Architecture:
***Choices made for the application:***
### Pattern:
Application is utilising MVVM as this is recommended by apple pattern, also in such small application there is no reason to write more complicated code by implementing other patterns.

### Networking:
Application is using custom networking layer providing ease of use. I reused network layer from my old app that I was working on some time ago and adjusted it to needs of the app. I made this choice so the project is not dependent on libraries such as Alamofire, so updating the packages won't brake functionalities. 

## Features

- Search - To change modes we need to tap on 'Search mode' button
-- Searching for tags (either all tags matching, or any matching from the list)
-- Searching for people
- Recent images - By default application loads to 'Recent images' Tumblr section as this was the endpoint that does not require any authentication
- User details - Showing all images that user added
- Photo detail - Showing some details about the photography - Dates taken, posted, and title + description. I've added some EXIF details (where applicable) as this is quite interesting information about the device that the image was taken from.
- Infinite scrolling where applicable

## Decisions made
I had to made some compromises to meet the deadline and keep sort of logical behaviour of the application. 
- Search field and its modes. I was not sure what would be the best way to implement this, so currently to search for users and/or tags we have to select search mode, which I realised is not the best way to go probably. If I was going to implement this again I would actually make users/tags api call concurrently since we are only getting one user object instead of array of objects with paginated api so it wouldn't be something that would increase loading time at least not massively.

## Testing
Application currently have very basic test cases as I have not enough time to write proper test scenarios and actual unit/UI tests.
