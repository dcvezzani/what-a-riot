<hello-world>
  <p>{ opts.greeting } <trim length="3" value="{ what }"/>!</p>
  this.what = "egghead"
  //this.what = "Cabeza de Huevo"
</hello-world>

<trim>
  <span>{ opts.value.substr(0, opts.length) }</span>
</trim>

