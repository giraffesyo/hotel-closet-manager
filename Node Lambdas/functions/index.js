const functions = require('firebase-functions')
const admin = require('firebase-admin')
const serviceAccount = require('./key.json')

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://hotel-management-5d4ed.firebaseio.com/'
})

const psk =
  'Xh$N56@0,QD(N(34H6H;tpLk+~gT]R/H}y}KkP=;|r}ttOmsu7ZVl[]doHjr[{zCL,SRz)HdFUS.Dj$u'

exports.createUser = functions.https.onRequest((request, response) => {
  console.log(request.body)
  if (request.body.psk !== psk) {
    response.send({ success: false, result: 'Invalid psk' })
    return
  } else {
    //valid connection

    // get email and password from body
    const { email, password } = request.body
    admin
      .auth()
      .createUser({
        email,
        emailVerified: true,
        password, 
      })
      .then(userRecord => {
        return response.send({ success: true, result: userRecord.uid })
      })
      .catch(error => {
        return response.send({ success: false, result: error })
      })
  }
})

exports.updateUser = functions.https.onRequest((request, response) => {
  const { uid, password } = request.body
  if (request.body.psk !== psk) {
    return response.send({ success: false, result: 'Invalid psk' })
  } else {
    admin
      .auth()
      .updateUser(uid, { password })
      .then(userRecord => {
        return response.send({ success: true, result: userRecord.toJSON() })
      })
      .catch(error => {
        return response.send({ success: false, result: error })
      })
  }
})


/*
// Keeps track of the length of the 'users' child list in a separate property.
exports.countUsers = functions.database.ref('/users').onWrite(
  (event) => {
    console.log(event)
    console.log(event.data)
    console.log('number of users: ', event.numChildren())
    return event.data.ref.parent.child("count/users").set(event.numChildren())
  });

*/ /*
// If the number of users gets deleted, recount the number of users
exports.recountUsers = functions.database.ref('/users/users_count').onDelete((snap) => {
const counterRef = snap.ref;
const collectionRef = counterRef.parent

// Return the promise from counterRef.set() so our function
// waits for this async event to complete before it exits.
return collectionRef.once('value')
    .then((messagesData) => counterRef.set(messagesData.numChildren()));
});

*/
/*
exports.listUsers = functions.https.onRequest((request, response) => {
  const { nextPageToken } = request.body
  if (request.body.psk !== psk) {
    response.send({ success: false, result: 'Invalid psk' })
    return
  } else {
    admin
      .auth()
      .listUsers(1000, nextPageToken)
      .then(listUsersResult => {
        return response.send({ success: true, result: listUsersResult.users })
      })
      .catch(error => {
        return response.send({ success: false, result: error })
      })
  }
})
*/
