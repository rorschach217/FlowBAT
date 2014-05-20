insertData = (data, collection) ->
  if collection.find().count() is 0
    for element in data
      element._id = collection.insert(element)
    return true

share.loadFixtures = ->
  now = new Date()
  lastWeek = new Date(now.getTime() - 7 * 24 * 3600 * 1000)
  MeteorUsersData = [
    {
      _id: "MortenJohansenUser"
      profile:
        name: "Morten Johansen"
        locale: "no"
      emails: [
        {
          address: "denis.gorbachev+meetings.morten@faster-than-wind.ru"
          verified: true
        }
      ]
      services:
        password: #123123
          srp:
            identity: "yE3SDLstoyKgho6aw"
            salt: "2KaD5ByuLFiB9D67m"
            verifier: "a9cd2d77478f4538a31651af4e9030a2e39da29ad335725054dcef3efd256caab0387964920bb924eddd17f8b20498a109e652ace08e514ed16cc0e38e352cde5edae0f56fae6feb3f37e4afee5ca96fb473fad9ab70d5a5307e662a377e79c9e4aa99e4fd5983d7ca2df98c07fd631f3a693da42ad92249b3b9fae36f7e8e40"
      createdAt: lastWeek
    }
    {
      _id: "DenisGorbachevUser"
      profile:
        name: "Denis Gorbachev"
        phone: "+79199680040"
        locale: "en"
      emails: [
        {
          address: "denis.gorbachev+meetings.denis@faster-than-wind.ru"
          verified: false
        }
      ]
      services:
        password: #123123
          srp:
            identity: "yE3SDLstoyKgho6aw"
            salt: "2KaD5ByuLFiB9D67m"
            verifier: "a9cd2d77478f4538a31651af4e9030a2e39da29ad335725054dcef3efd256caab0387964920bb924eddd17f8b20498a109e652ace08e514ed16cc0e38e352cde5edae0f56fae6feb3f37e4afee5ca96fb473fad9ab70d5a5307e662a377e79c9e4aa99e4fd5983d7ca2df98c07fd631f3a693da42ad92249b3b9fae36f7e8e40"
      createdAt: lastWeek
    }
  ]
  allUsersIds = []
  for user in MeteorUsersData
    allUsersIds.push(user._id);
  insertData(MeteorUsersData, Meteor.users)

#  AccountsLoginServiceConfigurationData = [
#    {
#      service: "google",
#      clientId: Meteor.settings.public.google.clientId,
#      secret: Meteor.settings.google.secret
#    }
#  ]
#  insertData(AccountsLoginServiceConfigurationData, Accounts.loginServiceConfiguration)
