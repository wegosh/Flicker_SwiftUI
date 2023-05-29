# Flicker_SwiftUI

## SPM Packages Used:
- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI): Used for displaying images from URLs and benefiting from image caching capabilities.

## Architecture:
### Pattern: 
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

## Additional features:
The additional feature I implemented, inspired by my interest in photography, is the inclusion of EXIF data. EXIF data provides insightful information about how an image was captured, including camera settings, exposure details, and other technical metadata. It serves as a helpful resource for analyzing and understanding the techniques used to capture the photo, offering valuable insights and potentially guiding users in achieving similar results in their own photography endeavors.

## Decisions Made:

To meet the project deadline and maintain logical app behavior, some compromises were made:

- Search field and its modes: Currently, to search for users or tags, users must select the search mode. In retrospect, a better approach would have been to make concurrent API calls for users and tags, as the user search API provides a single user object rather than an array of objects, so the impact on loading times would be minimal.

## Testing:

The application currently has basic test cases, as time constraints did not allow for comprehensive unit and UI testing while keeping the functionality implemented.
