fs     = require 'fs'
faker  = require 'faker'

module.exports =

  generateUsers: ->

    users = []

    for i in [1..1]

      name     = faker.Name.findName()
      username = faker.Helpers.slugify(faker.Internet.userName()).toLowerCase().replace(/\./g, '').replace(/_/g, '')
      posts    = (faker.Lorem.paragraphs() for i in [1..10])
      comments = (faker.Lorem.paragraph()  for i in [1..10])

      while username.length < 8
        username = faker.Helpers.slugify(faker.Internet.userName().toLowerCase()).replace(/\./g, '').replace(/_/g, '')

      username = username + Date.now()
      password = @getPassword()

      email = "kodingtestuser+#{username}@koding.com"

      users.push { name, email, username, password }


    fs.writeFileSync 'users.json', JSON.stringify(users), 'utf-8'

    return users


  getPassword: ->

    password = faker.Helpers.slugify(faker.Internet.userName())

    while password.length < 12
      password = faker.Helpers.slugify(faker.Internet.userName())

    return password


  getUser: (createNewUserData) ->

    if createNewUserData
      users = @generateUsers()
      return users[0]

    try
      usersFile = fs.readFileSync('users.json')
      users = JSON.parse(usersFile)

      console.log '✔  users.json found, returning first user'
      return users[0]

    catch
      console.log '✔  users.json does not exist, creating new user data'

      users = @generateUsers()
      return users[0]
