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
    // self.comments.push(newTodo) 

    // self.trigger('message_changed', "adding")

    var theDate = new Date();
    var fdata = {'comment[author_id]': 1, 
      'comment[body]': newTodo["body"], 
      'comment[recorded_on(1i)]': theDate.getFullYear(), 
      'comment[recorded_on(2i)]': (theDate.getMonth()+1), 
      'comment[recorded_on(3i)]': theDate.getDate(), 
      'comment[recorded_on(4i)]': theDate.getHours(), 
      'comment[recorded_on(5i)]': theDate.getMinutes()
    }
    // console.log("fdata: " + fdata)

    var newItem = null;

    $.when( self.add(fdata) ).then(
      function(data){
        newItem = JSON.stringify(data)
        // self.trigger('message_changed', "done adding: " + JSON.stringify(data))
        return self.list()
      }, 
      function(status){ console.log("error: "   + status) }, 
      function(status){ console.log("waiting: " + status) }
    )
    .then(
      function(data){
        self.comments = data
        self.trigger('comments_changed', self.comments)
        self.trigger('message_changed', "done fetching; added " + newItem, {fade: true})
      }, 
      function(status){ console.log("error: "   + status) }, 
      function(status){ console.log("waiting: " + status) }
    )
  })

  self.on('comment_remove', function(url) {
    // self.comments.pop()
    // self.trigger('comments_changed', self.comments)

    $.when( self.remove(url) ).then(
      function(data){
        return self.list()
      }, 
      function(status){ console.log("error: "   + status) }, 
      function(status){ console.log("waiting: " + status) }
    )
    .then(
      function(data){
        self.comments = data
        self.trigger('comments_changed', self.comments)
        self.trigger('message_changed', "done removing item", {fade: true})
      }, 
      function(status){ console.log("error: "   + status) }, 
      function(status){ console.log("waiting: " + status) }
    )
  })

  self.on('comment_update', function(fdata = {}, postproc = function(){}) {
    $.when( self._update(fdata) ).then(
      function(data){
        postproc()
        return self.list()
      }, 
      function(status){ console.log("error: "   + status) }, 
      function(status){ console.log("waiting: " + status) }
    )
    .then(
      function(data){
        self.comments = data
        self.trigger('comments_changed', self.comments)
        self.trigger('message_changed', "done updating item", {fade: true})
      }, 
      function(status){ console.log("error: "   + status) }, 
      function(status){ console.log("waiting: " + status) }
    )
  })

  self.on('comment_init', function() {
    self.trigger('comments_changed', self.comments)
  })

  // The store emits change events to any listening views, so that they may react and redraw themselves.

  self.list = function(){
    var dfd = jQuery.Deferred();
    $.get('http://localhost:3672/comments.json')
      .fail(function(data) { dfd.reject( "fail" ); })
      .done(function(data) { dfd.resolve( data ); });
    return dfd.promise();
  }

  self.token = function(){
    var dfd = jQuery.Deferred();
    $.get('http://localhost:3672/comments/new')
      .fail(function(data) { dfd.reject( data ); })
      .done(function(data) { 
        var form = $("<div>" + data + "</div>").find('form')[0]
        var authenticity_token = $(form).find('input[name="authenticity_token"]').val();
        dfd.resolve( {authenticity_token: authenticity_token} ); });
    return dfd.promise();
  }

  self.add = function(data){
    var dfd = jQuery.Deferred();
    $.when( self.token() ).then(
      function(tdata){
        data['authenticity_token'] = tdata['authenticity_token']
        $.ajax('http://localhost:3672/comments', {type: "POST", data: data, success: function(){}, dataType: 'json'})
          .fail(function(data) { dfd.reject( data ); })
          .done(function(data) { dfd.resolve( data ); });
      }, 
      function(status){ console.log("error: "   + status) }, 
      function(status){ console.log("waiting: " + status) }
      );
    return dfd.promise();
  }

  self.remove = function(url){
    var dfd = jQuery.Deferred();
    $.when( self.token() ).then(
      function(data){
        $.ajax(url, {type: "DELETE", data: data, success: function(){}, dataType: 'json'})
          .fail(function(data) { dfd.reject( data ); })
          .done(function(data) { dfd.resolve( data ); });
      }, 
      function(status){ console.log("error: "   + status) }, 
      function(status){ console.log("waiting: " + status) }
      );
    return dfd.promise();
  }

  self._update = function(fdata){
    var dfd = jQuery.Deferred();
    $.when( self.token() ).then(
      function(tdata){
      var cdata = "authenticity_token=" + encodeURIComponent(tdata.authenticity_token) + "&" + fdata.data
        $.ajax(fdata.url, {type: "PUT", data: cdata, success: function(){}, dataType: 'json'})
          .fail(function(data) { dfd.reject( data ); })
          .done(function(data) { dfd.resolve( data ); });
      }, 
      function(status){ console.log("error: "   + status) }, 
      function(status){ console.log("waiting: " + status) }
      );
    return dfd.promise();
  }

  // when the js is loaded, initialize with list of comments
  $.when( self.list() ).then(
    function(data){
      self.comments = data
      self.trigger('comments_changed', self.comments)
    }, 
    function(status){ console.log("error: "   + status) }, 
    function(status){ console.log("waiting: " + status) }
    );
}
