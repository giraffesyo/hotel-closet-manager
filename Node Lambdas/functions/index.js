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
    const {email, password, administrator} = request.body
    admin
      .auth()
      .createUser({
        email,
        emailVerified: true,
        password
      })
      .then(userRecord => {
        return response.send({ success: true, result: userRecord.uid })
      })
      .catch(error => {
        return response.send({ success: false, result: error })
      })
  }
})

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
