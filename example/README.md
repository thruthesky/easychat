# Example App of EasyChat

* Example App for easy understading of how you can use EasyChat.



## Flowchart


### Chat room life cyle flowchart


```mermaid
flowchart TD
roomList(Chat Room List Screen)
roomList-->createRoomPopup[/Chat Room Create Popup/]
roomList-->chatRoom
createRoomPopup-->createRoomPopupCreate{Create or No?}
createRoomPopupCreate--No-->roomList
createRoomPopupCreate--Yes-->chatRoom(Chat Room)
chatRoom-->inviteUser(Invite User)
chatRoom-->beginChat
chatRoom-->leave-->roomList
inviteUser-->inviteUserSearch(Search User)-->invite{Invite or No?}
invite--Yes-->updateDatabase-->chatRoom
invite--No-->chatRoom
beginChat-->uploadPhoto
chatRoom-->master{If you are a master?}-->chatRoomSettings(TODO: Add more settings)
```





### Chat message send flowchart

```mermaid
flowchart TD
inputBox-->sendMessage
sendMessage-->updateRoom
sendMessage-->cloudFunctions>Cloud Functions]-->notification(Send Push Notification)
```

### Photo send flowchat

