User.create(
  [
    {
      username: 'testuser',
      email: 'sampleuser@example.com',
      password: 'password'
    },
    {
      username: 'otheruser',
      email: 'sampleuser1@example.com',
      password: 'password'
    }
  ]
)
Post.create(
  [
    {
      user_id: 1,
      title: 'sample title 1',
      content: 'this is sample text okay'
    },
    {
      user_id: 1,
      title: 'sample title 2',
      content: 'this is sample text okay',
      published: true
    },
    {
      user_id: 2,
      title: 'sample title 3',
      content: 'this is sample text okay'
    },
    {
      user_id: 2,
      title: 'sample title 4',
      content: 'this is sample text okay',
      published: true
    }
  ]
)