# Flicker_SwiftUI

## SPM Packages Used:
- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI): Used for displaying images from URLs and benefiting from image caching capabilities.

## Architecture:
The application follows the MVVM (Model-View-ViewModel) architecture pattern, which is recommended by Apple. For this small-scale application, MVVM provides a suitable structure without introducing unnecessary complexity.

### Networking:
The app utilizes a custom networking layer, which was adapted from a previous project. This decision was made to avoid dependencies on external libraries like Alamofire. By using a custom networking layer, the project remains independent of specific libraries, and updating packages won't disrupt functionality.

## Features:

- Search: The app offers a search feature with two modes:
  - Searching for tags: Allows searching for images matching specific tags.
  - Searching for people: Enables searching for images uploaded by specific users.

- Recent images: Upon launching the app, it loads the "Recent images" section from the Tumblr API, as it doesn't require authentication.

- User details: Displays all images uploaded by a selected user.

- Photo detail: Shows details about a photo, including dates taken and posted, title, description, and relevant EXIF information when available.

- Infinite scrolling: Implemented where applicable, allowing users to scroll through an endless list of content.

## Decisions Made:

To meet the project deadline and maintain logical app behavior, some compromises were made:

- Search field and its modes: Currently, to search for users or tags, users must select the search mode. In retrospect, a better approach would have been to make concurrent API calls for users and tags, as the user API provides a single user object rather than an array of objects. This change would minimize the impact on loading time.

## Testing:

The application currently has basic test cases, as time constraints did not allow for comprehensive unit and UI testing. Given more time, proper test scenarios and testing in different areas would be implemented.
