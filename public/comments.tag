<comments>
  <button onclick={ fetchNew }>new comment</button>
  <button onclick={ fetchAll }>all comments</button>

  <!-- div class="comments" if={comment_list}>{ JSON.stringify(comment_list) }</div -->
  <p></p>

  <div class="comment-list">
    <comment each={ comment_list }></comment>
  </div>

  <comment-new-form name="comment_new_form" style="display: none"></comment-new-form>
  <comment-edit-form name="comment_edit_form" style="display: none"></comment-edit-form>

  var self = this

  getRecordedOn(form) {
    parts = []
    $( "#myselect option:selected" ).text();
    parts[parts.length] = $(form).find('select[name="comment[recorded_on(1i)]"] option:selected').val();
    parts[parts.length] = $(form).find('select[name="comment[recorded_on(2i)]"] option:selected').val();
    parts[parts.length] = $(form).find('select[name="comment[recorded_on(3i)]"] option:selected').val();
    parts[parts.length] = $(form).find('select[name="comment[recorded_on(4i)]"] option:selected').val();
    parts[parts.length] = $(form).find('select[name="comment[recorded_on(5i)]"] option:selected').val();
    return parts
  }

  fetchNew() {
    self.tags.comment_new_form.message = ''
    $(self.root).find(".comment-list").hide()
    $(self.root).find("comment-edit-form").hide()
    $.get('http://localhost:3672/comments/new')
      .done(function(data) {
        var form = $("<div>" + data + "</div>").find('form')[0]
        var authenticity_token = $(form).find('input[name="authenticity_token"]').val();
        var comment_author_id = $(form).find('input[name="comment[author_id]"]').val();
        var comment_body = $(form).find('textarea[name="comment[body]"]').val();
        var comment_recorded_on = self.getRecordedOn(form)
        /* var comment_recorded_on = ["2015", "12", "31", "07", "21"] */

        $(self.root).find('comment-new-form').show()
        self.tags.comment_new_form.init()
        
        self.update({ authenticity_token: authenticity_token, author_id: comment_author_id, body: comment_body, recorded_on: comment_recorded_on })
      });
  }

  fetchAll() {
    $(self.root).find("comment-edit-form").hide()
    $(self.root).find("comment-new-form").hide()
    self.tags.comment_new_form.message = ''
    self.tags.comment.message = ''
    $.get('http://localhost:3672/comments.json')
      .done(function(data) {
        $(self.root).find(".comment-list").show()
        self.comment_list = data
        self.update()
      });
  }
</comments>

<comment>
<span class="tooltip" show={ message }>{ message }</span>
  <li>{ author_id } : { recorded_on } : { body } | <a href="http://localhost:3672/comments/{ id }">show</a> | <a href="http://localhost:3672/comments/{ id }" onclick={ editRecord }>edit</a> | <a href="http://localhost:3672/comments/{ id }" onclick={ deleteRecord }>delete</a></li>

  var self = this

  editRecord(){
    var comment_url = this.url

    $(self.parent.root).find("comment-new-form").hide()
    /* $(self.parent.root).find(".comment-list").hide() */

    /* self.tags.comment_new_form.message = '' */
    /* self.comment_list = '' */
    $.get(comment_url)
      .fail(function(data) {
        self.message = JSON.stringify(data.responseJSON)
        self.update()
      })
      .done(function(data) {
        $(self.parent.root).find('comment-edit-form').show()
        self.form = $(self.root).find('form')[0]
        self.parent.tags.comment_edit_form.init()
        /* self.parent.tags.comment_edit_form.update({"id":18,"author_id":1,"recorded_on":["2015", "12", "31", "15", "58"],"body":"lkj elrktjel rkjle rkjle rkj"}) */
        self.parent.tags.comment_edit_form.update(data)
      });
  }

  deleteRecord(){
    var comment_url = this.url
    
    $.get('http://localhost:3672/comments/new')
      .done(function(data) {
        var form = $("<div>" + data + "</div>").find('form')[0]
        self.authenticity_token = $(form).find('input[name="authenticity_token"]').val();
      }).promise().done(function(){

      var data = {authenticity_token: self.authenticity_token}
      $.ajax(comment_url, {type: "DELETE", data: data, success: function(){}, dataType: 'json'})
        .fail(function(data) {
          self.message = JSON.stringify(data.responseJSON)
          self.update()
        })
        .done(function(data) {
          self.message = 'successfully deleted comment: ' + comment_url
          self.update()

          /* $(self.root).find("li").hide() */

          $(self.parent.root).find("comment-edit-form").hide()
          $(self.root).find("li").fadeOut( "slow", function() {
            $(self.root).fadeOut( "slow", function() {})
          });
        });
      
      })
  }
</comment>

<comment-edit-form>
<span class="tooltip" show={ message }>{ message }</span>

<div class="comment-edit-form" style=""><h1>Edit Comment</h1>

<form method="post" accept-charset="UTF-8" action="/comments/{ id }" id="edit_comment_{ id }" class="edit_comment"><input type="hidden" value="✓" name="utf8"><input type="hidden" value="patch" name="_method"><input type="hidden" value="{ authenticity_token }" name="authenticity_token">

  <div class="field">
    <label for="comment_author_id">Author</label><br>
    <input type="number" id="comment_author_id" name="comment[author_id]" value="{ author_id }">
  </div>
  <div class="field">
    <date-time-picker label='Recorded on' model='comment' attribute='recorded_on' value={ recorded_on }></date-time-picker>
  </div>
  <div class="field">
    <label for="comment_body">Body</label><br>
    <textarea id="comment_body" name="comment[body]">{ body }</textarea>
  </div>
  <div class="actions">
    <input type="button" value="Update Comment" name="commit" onclick={ updateRecord } />
  </div>
</form>
</div>

  var self = this

  init() {
    self.form = $(self.root).find('form')[0]
  }


  /* createNew() { */
  /*   var form = $(self.root).find('.comment-new-form form') */
  /*    */
  /*   $.post('http://localhost:3672/comments', form.serialize(), function(){}, 'json') */
  /*     .fail(function(data) { */
  /*       self.message = JSON.stringify(data.responseJSON) */
  /*       self.update() */
  /*     }) */
  /*     .done(function(data) { */
  /*       self.message = 'successfully created new comment: ' + JSON.stringify(data) */
  /*       $(form)[0].reset() */
  /*       self.update() */
  /*     }); */
  /* } */

</comment-edit-form>

<comment-new-form>
<span class="tooltip" show={ message }>{ message }</span>

<div class="comment-new-form" style=""><h1>New Comment</h1>

<form method="post" accept-charset="UTF-8" action="/comments" id="new_comment" class="new_comment"><input type="hidden" value="✓" name="utf8"><input type="hidden" value="{ authenticity_token }" name="authenticity_token">

  <div class="field">
    <label for="comment_author_id">Author</label><br>
    <input type="number" id="comment_author_id" name="comment[author_id]" value="{ author_id }">
  </div>
  <div class="field">
    <date-time-picker label='Recorded on' model='comment' attribute='recorded_on' value={ recorded_on }></date-time-picker>
  </div>
  <div class="field">
    <label for="comment_body">Body</label><br>
    <textarea id="comment_body" name="comment[body]">{ body }</textarea>
  </div>
  <div class="actions">
    <input type="button" value="Create Comment" name="commit" onclick={ createNew } />
  </div>
</form>
</div>

  var self = this

  init() {
    self.form = $(self.root).find('form')[0]
  }

  createNew() {
    $.post('http://localhost:3672/comments', $(self.form).serialize(), function(){}, 'json')
      .fail(function(data) {
        self.message = JSON.stringify(data.responseJSON)
        self.update()
      })
      .done(function(data) {
        self.message = 'successfully created new comment: ' + JSON.stringify(data)
        $(self.form)[0].reset()
        self.update()
      });
  }

</comment-new-form>





<date-time-picker>
    <label for="{ opts.model }_{ opts.attribute }">{ opts.label }</label><br>
    <select name="{ opts.model }[{ opts.attribute }(1i)]" id="{ opts.model }_{ opts.attribute }_1i">
<option value="2010">2010</option>
<option value="2011">2011</option>
<option value="2012">2012</option>
<option value="2013">2013</option>
<option value="2014">2014</option>
<option value="2015">2015</option>
<option value="2016">2016</option>
<option value="2017">2017</option>
<option value="2018">2018</option>
<option value="2019">2019</option>
<option value="2020">2020</option>
</select>
<select name="{ opts.model }[{ opts.attribute }(2i)]" id="{ opts.model }_{ opts.attribute }_2i">
<option value="1">January</option>
<option value="2">February</option>
<option value="3">March</option>
<option value="4">April</option>
<option value="5">May</option>
<option value="6">June</option>
<option value="7">July</option>
<option value="8">August</option>
<option value="9">September</option>
<option value="10">October</option>
<option value="11">November</option>
<option value="12">December</option>
</select>
<select name="{ opts.model }[{ opts.attribute }(3i)]" id="{ opts.model }_{ opts.attribute }_3i">
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
<option value="8">8</option>
<option value="9">9</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
<option value="13">13</option>
<option value="14">14</option>
<option value="15">15</option>
<option value="16">16</option>
<option value="17">17</option>
<option value="18">18</option>
<option value="19">19</option>
<option value="20">20</option>
<option value="21">21</option>
<option value="22">22</option>
<option value="23">23</option>
<option value="24">24</option>
<option value="25">25</option>
<option value="26">26</option>
<option value="27">27</option>
<option value="28">28</option>
<option value="29">29</option>
<option value="30">30</option>
<option value="31">31</option>
</select>
 &mdash; <select name="{ opts.model }[{ opts.attribute }(4i)]" id="{ opts.model }_{ opts.attribute }_4i">
<option value="00">00</option>
<option value="01">01</option>
<option value="02">02</option>
<option value="03">03</option>
<option value="04">04</option>
<option value="05">05</option>
<option value="06">06</option>
<option value="07">07</option>
<option value="08">08</option>
<option value="09">09</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
<option value="13">13</option>
<option value="14">14</option>
<option value="15">15</option>
<option value="16">16</option>
<option value="17">17</option>
<option value="18">18</option>
<option value="19">19</option>
<option value="20">20</option>
<option value="21">21</option>
<option value="22">22</option>
<option value="23">23</option>
</select>
 : <select name="{ opts.model }[{ opts.attribute }(5i)]" id="{ opts.model }_{ opts.attribute }_5i">
<option value="00">00</option>
<option value="01">01</option>
<option value="02">02</option>
<option value="03">03</option>
<option value="04">04</option>
<option value="05">05</option>
<option value="06">06</option>
<option value="07">07</option>
<option value="08">08</option>
<option value="09">09</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
<option value="13">13</option>
<option value="14">14</option>
<option value="15">15</option>
<option value="16">16</option>
<option value="17">17</option>
<option value="18">18</option>
<option value="19">19</option>
<option value="20">20</option>
<option value="21">21</option>
<option value="22">22</option>
<option value="23">23</option>
<option value="24">24</option>
<option value="25">25</option>
<option value="26">26</option>
<option value="27">27</option>
<option value="28">28</option>
<option value="29">29</option>
<option value="30">30</option>
<option value="31">31</option>
<option value="32">32</option>
<option value="33">33</option>
<option value="34">34</option>
<option value="35">35</option>
<option value="36">36</option>
<option value="37">37</option>
<option value="38">38</option>
<option value="39">39</option>
<option value="40">40</option>
<option value="41">41</option>
<option value="42">42</option>
<option value="43">43</option>
<option value="44">44</option>
<option value="45">45</option>
<option value="46">46</option>
<option value="47">47</option>
<option value="48">48</option>
<option value="49">49</option>
<option value="50">50</option>
<option value="51">51</option>
<option value="52">52</option>
<option value="53">53</option>
<option value="54">54</option>
<option value="55">55</option>
<option value="56">56</option>
<option value="57">57</option>
<option value="58">58</option>
<option value="59">59</option>
</select>

  var self = this

  self.on('update', function() {
    if(opts.value != undefined){
      $.each(opts.value, function( index, value ) {
        var sel_name = 'select[name="' + opts.model + '[' + opts.attribute + '(' + (index+1) + 'i)]"]'
        var sel_ctl = $(self.parent.form).find(sel_name)
        $(sel_ctl).val(value)
      });
    }
  })

</date-time-picker>

