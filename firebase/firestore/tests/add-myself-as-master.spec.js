const assert = require("assert");
const { db, a, b, fakeChatRoomData } = require("./setup");

// load firebase-functions-test SDK
const firebase = require("@firebase/testing");

describe("Firestore security test", () => {
  it("Add myself as a master to the chat room user -> success", async () => {
    // create a chat room
    const ref = await firebase.assertSucceeds(
      db(b)
        .collection("easychat")
        .add(fakeChatRoomData({ master: b.uid }))
    );
    console.log(ref.id);
    // add myself as a mater because there is no uid.
    await firebase.assertSucceeds(
      db(b)
        .collection("easychat")
        .doc(ref.id)
        .collection("users")
        .doc(b.uid)
        .set({ createdAt: new Date() })
    );
  });
});
