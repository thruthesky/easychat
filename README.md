# EasyChat

* This package helps the flutter developers to rapidly build chat app.

## Environment

* Firestore

## Features

* Chat room list
* 1:1 chat room & multi chat
* File upload api

## Setup


### Firestore Security Rules

* It uses the following collections
  * `/easy-chat-rooms` - chat room information.
  * `/easy-chat-messages` - chat message documents.

* Add the folling security rules.

```json
 ... security rules here ...
```


### Firebase settings

* Easychat package uses the same connection on your application. You can simply initialize firebase connection inside your application.


## TODO

- Updating user's display name and photo url in chat room collection. Not indivisual chat message.




## Usage

- You need to create only one screen to use the easychat.


```dart
Scafolld(
  appBar: AppBar(
    title:
  )
)
```



## Additional information

- Please create issues.