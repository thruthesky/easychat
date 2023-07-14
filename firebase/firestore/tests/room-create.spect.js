const assert = require("assert");
const { db, a, b, fakeChatRoomData } = require("./setup");

// load firebase-functions-test SDK
const firebase = require("@firebase/testing");

describe("Firestore security test", () => {
  it("Creating chat room without master -> fail", async () => {
    const testDoc = db().collection("easychat").doc();
    await firebase.assertFails(testDoc.set({ test: "test" }));
  });

  it("Creating chat room with wrong master uid -> fail", async () => {
    await firebase.assertFails(
      db(a)
        .collection("easychat")
        .add(fakeChatRoomData({ master: b.uid }))
    );
  });
  it("Creating chat room -> success", async () => {
    await firebase.assertSucceeds(
      db(a)
        .collection("easychat")
        .add(fakeChatRoomData({ master: a.uid }))
    );
  });
});
