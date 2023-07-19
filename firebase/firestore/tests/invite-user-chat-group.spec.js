const assert = require("assert");
const should = require('should');
const { db, a, b, c, createChatRoom } = require("./setup");

// load firebase-functions-test SDK
const firebase = require("@firebase/testing");

describe("Firestore security test chat room", () => {
    it("Inviting user C to the room by user A in an open room -> success", async () => {
        const roomRef = await createChatRoom(a, { master: a.uid, users: [a.uid, b.uid], open: true });
        await firebase.assertSucceeds(
            await db(a)
                .collection("easychat")
                .doc(roomRef.id)
                .update({ users: firebase.firestore.FieldValue.arrayUnion(c.uid) })
        );

        const doc = await db(c)
            .collection("easychat")
            .doc(roomRef.id)
            .get();
        // TODO
        console.log("tst " + doc.data().users.toString());
    });
});

