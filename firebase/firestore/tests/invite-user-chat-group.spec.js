const assert = require("assert");
const { db, a, b, c, createChatRoom } = require("./setup");

// load firebase-functions-test SDK
const firebase = require("@firebase/testing");

describe("Firestore security test chat room", () => {
    it("User A inviting user B to an open room made by user A -> success", async () => {
        // A creating open room
        const roomRef = await createChatRoom(a, { master: a.uid, users: [a.uid], open: true, group: true });
        // A inviting B
        await firebase.assertSucceeds(
            await db(a)
                .collection("easychat")
                .doc(roomRef.id)
                .update({ users: firebase.firestore.FieldValue.arrayUnion(b.uid) })
        );
        const doc = await db(a)
            .collection("easychat")
            .doc(roomRef.id)
            .get();
        assert.ok(doc.data().users.includes(b.uid));
    });
    it("User A inviting user B to an open room made by user A -> success", async () => {
        // A creating open room
        const roomRef = await createChatRoom(a, { master: a.uid, users: [a.uid], open: false, group: true });
        // A inviting B
        await firebase.assertSucceeds(
            await db(a)
                .collection("easychat")
                .doc(roomRef.id)
                .update({ users: firebase.firestore.FieldValue.arrayUnion(b.uid) })
        );
        const doc = await db(a)
            .collection("easychat")
            .doc(roomRef.id)
            .get();
        // Master can still invite a user even if the Group is closed
        assert.ok(doc.data().users.includes(b.uid));
    });
    it("User B inviting user C to an open room made by user A -> failure", async () => {
        // A creating closed room
        const roomRef = await createChatRoom(a, { master: a.uid, users: [a.uid], open: true, group: true });
        // A inviting B
        await firebase.assertSucceeds(
            await db(a)
                .collection("easychat")
                .doc(roomRef.id)
                .update({ users: firebase.firestore.FieldValue.arrayUnion(b.uid) })
        );
        const doc1 = await db(a)
            .collection("easychat")
            .doc(roomRef.id)
            .get();
        assert.ok(doc1.data().users.includes(b.uid));
        // B inviting C
        await firebase.assertFails(
            await db(b)
                .collection("easychat")
                .doc(roomRef.id)
                .update({ users: firebase.firestore.FieldValue.arrayUnion(c.uid) })
        );
        const doc2 = await db()
            .collection("easychat")
            .doc(roomRef.id)
            .get();
        // User C cannot be invited by B because B is not a master or moderator, and GC is closed.
        assert.ok(!doc2.data().users.includes(c.uid));
    });
    // it("Inviting user C to the room by user B in an open room -> success", async () => {
    //     // A creating room
    //     const roomRef = await createChatRoom(a, { master: a.uid, users: [a.uid], open: true, group: true });
    //     // A inviting B
    //     await firebase.assertSucceeds(
    //         await db(a)
    //             .collection("easychat")
    //             .doc(roomRef.id)
    //             .update({ users: firebase.firestore.FieldValue.arrayUnion(b.uid) })
    //     );
    //     const doc1 = await db(a)
    //         .collection("easychat")
    //         .doc(roomRef.id)
    //         .get();
    //     assert.ok(doc1.data().users.includes(b.uid));
    //     // B inviting C
    //     await firebase.assertSucceeds(
    //         await db(b)
    //             .collection("easychat")
    //             .doc(roomRef.id)
    //             .update({ users: firebase.firestore.FieldValue.arrayUnion(c.uid) })
    //     );
    //     const doc2 = await db(b)
    //         .collection("easychat")
    //         .doc(roomRef.id)
    //         .get();
    //     assert.ok(doc2.data().users.includes(c.uid));
    // });
    // it("Inviting user C to the room by user B in an closed room -> success", async () => {
    //     const roomRef = await createChatRoom(a, { master: a.uid, users: [a.uid, b.uid], open: true, group: true });
    //     await firebase.assertSucceeds(
    //         await db(b)
    //             .collection("easychat")
    //             .doc(roomRef.id)
    //             .update({ users: firebase.firestore.FieldValue.arrayUnion(c.uid) })
    //     );
    //     const doc = await db(c)
    //         .collection("easychat")
    //         .doc(roomRef.id)
    //         .get();
    //     assert.ok(doc.data().users.includes(c.uid));
    // });
});

