const assert = require("assert");
const { db, a, b, tempChatRoomData } = require("./setup");

// load firebase-functions-test SDK
const firebase = require("@firebase/testing");

describe("Firestore security test", () => {
  it("1:1 chat -> failure due to 1 user in users list", async () => {
    const ref = await firebase.assertFails(
      db(a)
        .collection("easychat")
        .add(tempChatRoomData({ master: a.uid, users: [a.uid] }))
    );
  });

  it("1:1 chat -> success", async () => {
    const ref = await firebase.assertSucceeds(
      db(a)
        .collection("easychat")
        .add(tempChatRoomData({ master: a.uid, users: [a.uid, b.uid] }))
    );
  });

  it("Creating chat room without master -> fail", async () => {
    const testDoc = db().collection("easychat").doc();
    await firebase.assertFails(testDoc.set({ users: [a.uid, b.uid] }));
  });

  it("Creating chat room with wrong master uid -> fail", async () => {
    await firebase.assertFails(
      db(a)
        .collection("easychat")
        .add(tempChatRoomData({ master: b.uid, users: [a.uid, b.uid] }))
    );
  });
});
