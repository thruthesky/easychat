const assert = require("assert");
const { db, a, b, c, tempChatRoomData, createChatRoom } = require("./setup");

// load firebase-functions-test SDK
const firebase = require("@firebase/testing");

describe("Chat room read test", () => {
    it("Read chat room - failure ", async () => {
        const roomRef = await createChatRoom(a, { master: a.uid, users: [a.uid, b.uid] });

        await firebase.assertFails(
            db(c)
                .collection("easychat")
                .doc(roomRef.id)
                .get()
        );
    });

    it("Read chat room - success ", async () => {
        const roomRef = await createChatRoom(a, { master: a.uid, users: [a.uid, b.uid] });

        await firebase.assertSucceeds(
            db(b)
                .collection("easychat")
                .doc(roomRef.id)
                .get()
        );
    });

    it("Read chat room that does not exist - success ", async () => {
        await firebase.assertSucceeds(await db(b)
            .collection("easychat")
            .doc('nonexistingroom')
            .get()
        );
    });


    it("Read chat room that exist but not room user - failure ", async () => {
        const roomRef = await createChatRoom(a, { master: a.uid, users: [a.uid, b.uid] });
        await firebase.assertFails(
            db(c)
                .collection("easychat")
                .doc(roomRef.id)
                .get()
        );
    });

});




