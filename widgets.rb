class Widgets

  @@widgets = [
      {name:"Facebook Like", identifiers:["fb-like","fb:like","facebook.com/plugins/like"]},
      {name:"Google Plus", identifiers:["g-follow","g-plusone", "Google plus follow","google plus plus +1 button","-google-plus" ]},
      {name:"Google Fonts Api", identifiers:["fonts.googleapis.com/css"]},
      {name:"Twitter", identifiers:['class="twitter', 'addthis > class="addthis"',"fa-twitter"]},
      {name:"Pinterest", identifiers:['assets.pinterest.com/images/pidgets','pinterest.com/pin/create/button/']},
      {name:"AddThis", identifiers:['class="addthis']},
      {name:"Font Awesome", identifiers:['maxcdn.bootstrapcdn.com/font-awesome']},
      {name:"TurboLinks", identifiers:['turbolinks']}

  ]

  def self.widgets
    @@widgets
  end
end