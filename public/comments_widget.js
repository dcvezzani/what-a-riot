// CommentsWidget definition.
// Flux stores house application logic and state that relate to a specific domain.
// In this case, a list of comment items.
function CommentsWidget() {
  riot.observable(this) // Riot provides our event emitter.
  
  var self = this

  self.comments = [ 
    { body: 'asdlf kjalsdkfj alsdkjf laskjdflakjsdlf kajsldfk ajlsdk jfalsdkfjl kj' },
    { body: 'elkjrelktj elkjlqwkjelqkw j kjwerlkjlwe krlkjwelkjlrl sdou isudofis duoi' }
  ]

  // Our store's event handlers / API.
  // This is where we would use AJAX calls to interface with the server.
  // Any number of views can emit actions/events without knowing the specifics of the back-end.
  // This store can easily be swapped for another, while the view components remain untouched.

  self.on('comment_add', function(newTodo) {
    self.comments.push(newTodo) 
    self.trigger('comments_changed', self.comments)        
  })

  self.on('comment_remove', function() {
    self.comments.pop()
    self.trigger('comments_changed', self.comments)
  })

  self.on('comment_init', function() {
    self.trigger('comments_changed', self.comments)
  })

  // The store emits change events to any listening views, so that they may react and redraw themselves.

}
