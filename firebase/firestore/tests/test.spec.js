const assert = require('assert');


// 파이어베이스 Unit test 모듈
const firebase = require('@firebase/testing');
// 테스트를 할 실제 파이어베이스 프로젝트 ID. 파이어베이스 콘솔에서 가져온다.
const TEST_PROJECT_ID = "withcenter-test-2";
const db = firebase.initializeTestApp({ projectId: TEST_PROJECT_ID }).firestore();


describe('Firestore security test', () => {
    it('Readonly', async () => {
        // Firestore 객체를 얻기
 
        const testDoc = db.collection('readonly').doc('testDoc');
 
 
        // `assertSucceeds()` 는 Firestore 에 동작을 실행하고, 성공하는 것을 예상하는 테스트이다.
        // `assertSucceeds()` 는 Promise 이므로, await 을 해야지만, 함수가 끝나기 전에 결과를 얻어서, 성공/실패를 표현 할 수 있다.
        // `assertSucceeds(testDoc.get())` 와 같이 해서, Firestore 동작을 테스트 하는 것이다.
        await firebase.assertSucceeds(testDoc.get());
    })
    it('Writing on readonly collection -> should be failed.', async () => {
        // Firestore 객체를 얻기
 
        const testDoc = db.collection('readonly').doc('testDoc');
 
 
        // `assertSucceeds()` 는 Firestore 에 동작을 실행하고, 성공하는 것을 예상하는 테스트이다.
        // `assertSucceeds()` 는 Promise 이므로, await 을 해야지만, 함수가 끝나기 전에 결과를 얻어서, 성공/실패를 표현 할 수 있다.
        // `assertSucceeds(testDoc.get())` 와 같이 해서, Firestore 동작을 테스트 하는 것이다.
        await firebase.assertFails(testDoc.set({ test: 'test' }));
    })


    it("Creating chat room by a master", async () => {

        const testDoc = db.collection('easy-chat-room').doc('testDoc');
        await firebase.assertFails(testDoc.set({ test: 'test' }));
    });
})

