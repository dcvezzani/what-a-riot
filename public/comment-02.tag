<comment-update>
  <div class="update-form">
    <form onsubmit={ _update }>
      <div class="row-entry">
        <div class="label">Author ID</div>
        <div class="field">
          <input type="text" name="comment[author_id]" value="{ author_id }" />
        </div>
      </div>
      
      <div class="row-entry">
        <div class="label">Body</div>
        <div class="field">
          <input type="text" name="comment[body]" value="{ body }" />
        </div>
      </div>

      <p>{ url }</p>
      <button>Update #{ id }</button>
    </form>
  </div>

  var self = this
  self.url = null

  init(data = {}){
    $(self.root).show()
    
    self.author_id = data.author_id
    self.body = data.body
    self.url = data.url

    self.update()
  }

  _update(e) {
    var form = $(e.target)
    var data = $(form).serialize()
    RiotControl.trigger('comment_update', {url: self.url, data: data}, function(){
      $(self.root).hide(); 
    })
  }

</comment-update>

<messages>
  <message></message>
  <button name="toggle_messages" onclick={ toggleMessages }>Show all messages</button>
  
  <div class="list"></div>

  var self = this

  toggleMessages(){
    var messageEntries = $(self.root).find("div.list div")
    var curButton = $(self.root).find("button:visible")
    var curStatus = ($(curButton).text().match(/^Show/)) ? 'active' : 'inactive'

    if(curStatus == 'active'){
      $(curButton).text("Hide all messages")
      $(messageEntries).show()
    } else {
      $(curButton).text("Show all messages")
      $(messageEntries).hide()
    }
  }

  add(msg){
    var newMsg = self.tags.message.clone(msg)
    console.log($(newMsg))

    var messages = $(self.root).find("div.list")
    $(newMsg).appendTo(messages).fadeIn( "slow" ).delay(2000).fadeOut( "slow" )

    // clean out messages
    if( false ){
      var messageEntries = $(self.root).find("div.list div")
      var msgCount = $(messageEntries).length
      while(msgCount > 5){
        $(messageEntries).first().remove()
        msgCount -= 1
      }
    }
  }
</messages>

<message>
  <div class="message" style="display: none; ">{ content }</div>

  var self = this

  init(content){
    self.content = content
    self.update()
  }

  clone(content){
    self.content = content
    self.update()

    var cloned = $(self.root).find('div.message').clone()
    self.content = ''
    self.update()

    return cloned
  }
</message>

<comment>

  <h3>{ opts.title }</h3>
  <messages></messages>

  <ul>
    <li each={ items }> 
    <div class="item">
      <div class="details">{ id }, { author_id }, { recorded_on } | <a href="http://localhost:3672/comments/{ id }">show</a> | <a href="http://localhost:3672/comments/{ id }" onclick={ edit }>edit</a> | <a href="http://localhost:3672/comments/{ id }" onclick={ remove }>delete</a></div>
      <div class="body">{ body }</div>
      <div class="url">{ url }</div>
    </div>

    </li>
  </ul>

  <ol style="display: none;">
    <li each={ items }>
      <label class={ completed: done }>
        <input type="checkbox" checked={ done } onclick={ parent.toggle }> { title }
      </label>
    </li>
  </ol>

  <form onsubmit={ add }>
    <input name="input" onkeyup={ xedit }>
    <button disabled={ !text }>Add #{ items.length + 1 }</button>
  </form>

  <comment-update name="comment_update"></comment-update>

  var self = this
  self.disabled = true
  self.items = []

  self.on('mount', function() {
    // Trigger init event when component is mounted to page.
    // Any store could respond to this.
    RiotControl.trigger('comment_init')
  })  

  // Register a listener for store change events.
  RiotControl.on('comments_changed', function(items) {
    self.items = items
    self.update()
  }) 

  RiotControl.on('message_changed', function(message, options = {}) {
    self.tags.messages.add(message)
  }) 

  xedit(e) {
    self.text = e.target.value
  }

  edit(e) {
    var value = $(e.target).closest("div.item").find("div.body").text()
    /* $(self.root).find("input[name=input]").val(value) */
    $(e.target).closest("div.item").find("div.url").text(e.target.href)
    /* self.text = value */

    data = {
      author_id: 1, 
      body: value, 
      url: e.target.href
    }
    self.tags.comment_update.init(data)
  }

  add(e) {
    if (self.text) {
      // Trigger event to all stores registered in central dispatch.
      // This allows loosely coupled stores/components to react to same events.
      RiotControl.trigger('comment_add', { body: self.text })
      // console.log("self.input.value: " + self.input.value)
      self.text = self.input.value = ''
    }
  }

  toggle(e) {
    var item = e.item
    item.done = !item.done
    return true
  }

  remove(e) {
    $(e.target).closest("div.item").find("div.url").text(e.target.href)
    RiotControl.trigger('comment_remove', e.target.href)
  }

</comment>
